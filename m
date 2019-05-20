Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D61B423C42
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 17:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391651AbfETPhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 11:37:20 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:45548 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732280AbfETPhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 11:37:20 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1F7FD3400AE;
        Mon, 20 May 2019 15:37:18 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 20 May
 2019 08:37:12 -0700
Subject: Re: [RFC PATCH v2 net-next 0/3] flow_offload: Re-add per-action
 statistics
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>
References: <88b3c1de-b11c-ee9b-e251-43e1ac47592a@solarflare.com>
 <9b137a90-9bfb-9232-b01b-6b6c10286741@solarflare.com>
 <20190519002218.b6bcz224jkrof7c4@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <7cdc59fd-e90f-6ff2-f429-257c8844be26@solarflare.com>
Date:   Mon, 20 May 2019 16:37:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190519002218.b6bcz224jkrof7c4@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24624.005
X-TM-AS-Result: No-5.229700-4.000000-10
X-TMASE-MatchedRID: L8tZF6zWW2obF9xF7zzuNfZvT2zYoYOwt3aeg7g/usDfUZT83lbkELdi
        R69VZCkLSNwWc6eoJk34rkB5p5SshdTv/8bnqQFpoxjrap5AGQvoAe+uy8BLNBHfiujuTbedzBg
        vDRB8bNIg9YPBBzsv7NksCgjDvYLoDIaTPs5YLz/iHyvyXeXh5mQBrQiRNt2IsHufvNUB8yb4II
        F+rykpCmoieMs/IBE0JDSW1TEpRmdKca0+41kHnPQxpA7auLwMKrwYtiFPEnVLbo78UlxMOKPFj
        JEFr+olSXhbxZVQ5H/3FLeZXNZS4EZLVcXaUbdisyHMa0lcFzY22tKnCQ2JewT+F7CMa8tLhZqn
        TbNSCqqeqD9WtJkSIw==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.229700-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24624.005
X-MDID: 1558366639-NBAneC8IgDUi
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/05/2019 01:22, Pablo Neira Ayuso wrote:
> On Fri, May 17, 2019 at 04:27:29PM +0100, Edward Cree wrote:
>> On 15/05/2019 20:39, Edward Cree wrote:
> [...]
>> Pablo, how do the two options interact with your netfilter offload?  I'm
>>  guessing it's easier for you to find a unique pointer than to generate
>>  a unique u32 action_index for each action.  I'm also assuming that
>>  netfilter doesn't have a notion of shared actions.
> It has that shared actions concept, see:
>
> https://netfilter.org/projects/nfacct/
>
> Have a look at 'nfacct' in iptables-extensions(8) manpage.
Thanks.  Looking at net/netfilter/nfnetlink_acct.c, it looks as though you
 don't have a u32 index in there; for the cookie approach, would the
 address of the struct nf_acct (casted to unsigned long) work to uniquely
 identify actions that should be shared?
I'm not 100% sure how nf (or nfacct) offload is going to look, so I might
 be barking up the wrong tree here.  But it seems like the cookie method
 should work better for you — even if you did have an index, how would you
 avoid collisions with TC actions using the same indices if both are in
 use on a box?  Cookies OTOH are pointers, so guaranteed unique :)

-Ed
