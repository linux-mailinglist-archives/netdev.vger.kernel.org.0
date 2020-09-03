Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0144425BD7B
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 10:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbgICIkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 04:40:07 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47985 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726266AbgICIkG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 04:40:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599122405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nkompj5IxHGnEPikK3tjox7kn9DQzhQmyMUxr6MfduU=;
        b=gAU2dhcjCXjB9cRCksONNpnCKv4McCDvFKn0UhXVG71jKwCDfgobKQ3PxkBJLrol6bDa+u
        mjMFORjpWQA+VB4v6ceD690oUlY1B4la6cPduX8OdawuLwAuhbkLGGTLZDzGcw8TIVrPG3
        dOSfezF/A9LItZgwmgQAdCA780C6TuE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-wYAvPqxcMZWIiuS14GZ_bg-1; Thu, 03 Sep 2020 04:40:00 -0400
X-MC-Unique: wYAvPqxcMZWIiuS14GZ_bg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CFF58015F6;
        Thu,  3 Sep 2020 08:39:58 +0000 (UTC)
Received: from ovpn-115-2.ams2.redhat.com (ovpn-115-2.ams2.redhat.com [10.36.115.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8309A19C59;
        Thu,  3 Sep 2020 08:39:55 +0000 (UTC)
Message-ID: <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
From:   Paolo Abeni <pabeni@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Kehuan Feng <kehuan.feng@gmail.com>
Cc:     Hillf Danton <hdanton@sina.com>, Jike Song <albcamus@gmail.com>,
        Josh Hunt <johunt@akamai.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Date:   Thu, 03 Sep 2020 10:39:54 +0200
In-Reply-To: <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
         <20200623134259.8197-1-mzhivich@akamai.com>
         <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
         <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
         <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
         <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com>
         <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
         <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com>
         <CANE52Ki8rZGDPLZkxY--RPeEG+0=wFeyCD6KKkeG1WREUwramw@mail.gmail.com>
         <20200822032800.16296-1-hdanton@sina.com>
         <CACS=qqKhsu6waaXndO5tQL_gC9TztuUQpqQigJA2Ac0y12czMQ@mail.gmail.com>
         <20200825032312.11776-1-hdanton@sina.com>
         <CACS=qqK-5g-QM_vczjY+A=3fi3gChei4cAkKweZ4Sn2L537DQA@mail.gmail.com>
         <20200825162329.11292-1-hdanton@sina.com>
         <CACS=qqKgiwdCR_5+z-vkZ0X8DfzOPD7_ooJ_imeBnx+X1zw2qg@mail.gmail.com>
         <CACS=qqKptAQQGiMoCs1Zgs9S4ZppHhasy1AK4df2NxnCDR+vCw@mail.gmail.com>
         <5f46032e.1c69fb81.9880c.7a6cSMTPIN_ADDED_MISSING@mx.google.com>
         <CACS=qq+Yw734DWhETNAULyBZiy_zyjuzzOL-NO30AB7fd2vUOQ@mail.gmail.com>
         <20200827125747.5816-1-hdanton@sina.com>
         <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
         <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-09-02 at 22:01 -0700, Cong Wang wrote:
> Can you test the attached one-line fix? I think we are overthinking,
> probably all
> we need here is a busy wait.

I think that will solve, but I also think that will kill NOLOCK
performances due to really increased contention.

At this point I fear we could consider reverting the NOLOCK stuff.
I personally would hate doing so, but it looks like NOLOCK benefits are
outweighed by its issues.

Any other opinion more than welcome!

Cheers,

Paolo

