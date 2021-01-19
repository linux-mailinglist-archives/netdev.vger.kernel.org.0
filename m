Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEDB2FB49A
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 09:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729991AbhASIyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 03:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727142AbhASIyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 03:54:35 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059F7C061574;
        Tue, 19 Jan 2021 00:53:53 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l1mlg-008dJr-2a; Tue, 19 Jan 2021 09:53:40 +0100
Message-ID: <d75b2c43a416d4bb84185aab4005d42e49962e36.camel@sipsolutions.net>
Subject: Re: net: tso: add UDP segmentation support: adds regression for
 ax200 upload
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Eric Dumazet <edumazet@google.com>,
        Ben Greear <greearb@candelatech.com>,
        Rainer Suhm <automat@posteo.de>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Date:   Tue, 19 Jan 2021 09:53:29 +0100
In-Reply-To: <CANn89iJWG2n1s3j7EdpwkQQv-9dOY02V+FGYHAWguO4JiqWuJA@mail.gmail.com> (sfid-20201221_201415_313104_E402A8E0)
References: <5664fa0f-aef2-c336-651a-093c9eed23ab@candelatech.com>
         <765f370d-ce2d-b75a-2dde-87f69ae7c185@candelatech.com>
         <CANn89iKpa1y2SKJuR9kRi=AZs94sj+-tzRs+2D0vmxh+ahEcGA@mail.gmail.com>
         <adbee2ec-c6ba-7a17-eb98-1c53365fa911@candelatech.com>
         <CANn89iJQnSVZFp2XDgREN1QMtU4exOsnJq=5VzJ6tqTCJ7MH-g@mail.gmail.com>
         <c4bcee7d-b2eb-759c-c659-d65f3e7daec9@candelatech.com>
         <CANn89i++Kgkj57ms70a5GDOQ-Cpewx3NQkzP3EmZmLYQ4eHzww@mail.gmail.com>
         <5d89fd24-f00a-7e70-00ce-83529f13b05e@candelatech.com>
         <20201218121627.603329b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <9003ea3720a03b4bd1b8abf3d8f645563a58f953.camel@sipsolutions.net>
         <43a5b45c-955a-22d4-2bf9-dbab852dbb5f@candelatech.com>
         <CANn89iJBO13s9fOVRnDyfj5HXt9wjnRpbh2_f5SuyNkNAfjzJQ@mail.gmail.com>
         <CANn89iJTCDof6ypxCkiGaPo+y0Bngg0NX5cLPWisTEZaFo1BQw@mail.gmail.com>
         <CANn89iJWG2n1s3j7EdpwkQQv-9dOY02V+FGYHAWguO4JiqWuJA@mail.gmail.com>
         (sfid-20201221_201415_313104_E402A8E0)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric, all,

Sorry we've been so silent on this.

> --- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
> @@ -773,6 +773,7 @@ iwl_mvm_tx_tso_segment(struct sk_buff *skb,
> unsigned int num_subframes,
> 
>         next = skb_gso_segment(skb, netdev_flags);
>         skb_shinfo(skb)->gso_size = mss;
> +       skb_shinfo(skb)->gso_type = ipv4 ? SKB_GSO_TCPV4 : SKB_GSO_TCPV6;
>         if (WARN_ON_ONCE(IS_ERR(next)))
>                 return -EINVAL;
>         else if (next)
> @@ -795,6 +796,7 @@ iwl_mvm_tx_tso_segment(struct sk_buff *skb,
> unsigned int num_subframes,
> 
>                 if (tcp_payload_len > mss) {
>                         skb_shinfo(tmp)->gso_size = mss;
> +                       skb_shinfo(tmp)->gso_type = ipv4 ?
> SKB_GSO_TCPV4 : SKB_GSO_TCPV6;
>                 } else {
>                         if (qos) {
>                                 u8 *qc;

This does fix the problems reported on iwlwifi, were you planning to
submit it as a proper patch?

Thanks,
johannes

