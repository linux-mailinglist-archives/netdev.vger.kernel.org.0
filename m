Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D991E8647
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 20:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgE2SIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 14:08:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28468 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725839AbgE2SId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 14:08:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590775712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ebn289xAAJGa4Oezihz1tcD9GNVoKIUezZ+dvb31Na0=;
        b=aZfQzNIiP7iex89qVHrJbyZPrm2kRQFFg/KnrLAKOI0IHj6glJQfp/PLOmSkgt40OQPMdf
        Y45faz/9pHoX3FaiVkjqdgQsLKB5uFf5T+QCDvE9d40nDb4VhBBu6BlkpAetCmTVc/jII+
        4fLtcjJGEL4vxIi9mgohBiweJLGPIU4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-hx9AwhsCM1au_ShzK3znVw-1; Fri, 29 May 2020 14:08:30 -0400
X-MC-Unique: hx9AwhsCM1au_ShzK3znVw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37AF0107ACCA;
        Fri, 29 May 2020 18:08:29 +0000 (UTC)
Received: from new-host-5 (unknown [10.40.193.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ADE9D5D9EF;
        Fri, 29 May 2020 18:08:27 +0000 (UTC)
Message-ID: <696c630f8c72f2a6a0674b69921fd500f1d5d4d1.camel@redhat.com>
Subject: Re: [PATCH net-next] net/sched: fix a couple of splats in the
 error path of tfc_gate_init()
From:   Davide Caratti <dcaratti@redhat.com>
To:     Po Liu <po.liu@nxp.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ivan Vecera <ivecera@redhat.com>
In-Reply-To: <VE1PR04MB6496BA8407706123819B9D31928F0@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <VE1PR04MB6496BA8407706123819B9D31928F0@VE1PR04MB6496.eurprd04.prod.outlook.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 29 May 2020 20:08:26 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.36.1 (3.36.1-1.fc32) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hi Po Liu,

On Fri, 2020-05-29 at 02:43 +0000, Po Liu wrote:
> Can you share the test step? 

sure, an invalid value of the control action is sufficient:

# tc action add action gate index 2 clockid CLOCK_TAI goto chain 42

> Clockid by default is set with CLOCK_TAI.

not in the error path of tcf_gate_init(), see below:

> And INIT_LIST_HEAD() also called in the init.

...ditto. In the error path of tcf_gate_init(), these two initializations
are not done. Looking at the call trace, validation of the control action
fails here:

365         err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
366         if (err < 0)
367                 goto release_idr;

then, the execution jumps to 'release_idr' thus skipping INIT_LIST_HEAD()
and hrtimer_init():

442 release_idr:
443         tcf_idr_release(*a, bind);
444         return err;

because of this, tcf_gate_cleanup() is invoked with

	'to_gate(*a)->param.entries'

all filled with zeros, and the same applies to

	'to_gate(*a)->hitimer'

and 

	'to_gate(*a)->param.tfcg_clockid'

> So I think maybe there is better method to avoid the duplicated code.

I'm not sure of what duplication you are referring to, but I suspect it's
those to_gate(*a) inside the if (ret == ACT_P_CREATED) { ... } statement:
I'm sending right now a v2 where I moved the assignment of 'gact' earlier.

Looking again at the error path of tcf_gate_init(), I suspect there is
another bug: the validation of 'tcfg_cycletime' and 'TCA_GATE_ENTRY_LIST'
is suspicious, because it overwrites the action's configuration with wrong
ones, thus causing semi-configured rules.
But it's unrelated to this kernel panic, so probably it deserves a
separate patch (and moreover, I don't have yet scripts that to verify it).
But I can follow-up on this in the next days, if you want.

thanks for looking at this,
-- 
davide

