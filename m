Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8A1E21A8A
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 17:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729295AbfEQP1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 11:27:38 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:60604 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729226AbfEQP1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 11:27:38 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5BC37A40059;
        Fri, 17 May 2019 15:27:35 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 17 May
 2019 08:27:30 -0700
Subject: Re: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
From:   Edward Cree <ecree@solarflare.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <88b3c1de-b11c-ee9b-e251-43e1ac47592a@solarflare.com>
Message-ID: <9b137a90-9bfb-9232-b01b-6b6c10286741@solarflare.com>
Date:   Fri, 17 May 2019 16:27:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <88b3c1de-b11c-ee9b-e251-43e1ac47592a@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24618.005
X-TM-AS-Result: No-8.071200-4.000000-10
X-TMASE-MatchedRID: csPTYAMX1+HmLzc6AOD8DfHkpkyUphL9vMRNh9hLjFk7sEw6V/IotDvP
        gRKDYJk/vFPDC9SycIVbEmPF90VeXtSefNlpHYem8VqfAfqY2ixwm7Nn/lGhVpiQXtm0V8JT8fN
        7z08uSw0Rz/FZ0QZ4tzJ0z+s/u8Dbo/Rz4V77tuRRUg+O1TsbkpAoP2KG7EfPmbdPE3zcujhOZz
        QThoQIn1psiiCQIKZH3B7MhNx6/Ye/WXZS/HqJ2gtuKBGekqUpOlxBO2IcOBYl3b04NMBHZ17p2
        5XJX5+mk1UO+EQtugnU+n3R2tGJiMAp6oII12UcQwymtxuJ6y0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.071200-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24618.005
X-MDID: 1558106857-3OLdFj8Ohanv
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/05/2019 20:39, Edward Cree wrote:
> A point for discussion: would it be better if, instead of the tcfa_index
>  (for which the driver has to know the rules about which flow_action
>  types share a namespace), we had some kind of globally unique cookie?
>  In the same way that rule->cookie is really a pointer, could we use the
>  address of the TC-internal data structure representing the action?  Do
>  rules that share an action all point to the same struct tc_action in
>  their tcf_exts, for instance?
A quick test showed that, indeed, they do; I'm now leaning towards the
 approach of adding "unsigned long cookie" to struct flow_action_entry
 and populating it with (unsigned long)act in tc_setup_flow_action().
Pablo, how do the two options interact with your netfilter offload?  I'm
 guessing it's easier for you to find a unique pointer than to generate
 a unique u32 action_index for each action.  I'm also assuming that
 netfilter doesn't have a notion of shared actions.

-Ed
