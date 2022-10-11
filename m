Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4443B5FB377
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 15:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiJKNdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 09:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiJKNdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 09:33:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA36B67C8C
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 06:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665495219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BwKevNcEB0+6PdYWVWLw2/PB3wIw6Wy0YkYQ4wNAVj0=;
        b=Q5F2BHPUShGVrpbc722KDnKNCtz8TZU2axGUHUS98QJvBbRfLsA+yX/MMnXkphGCTn9iV5
        32Atq6EIWtLlbT9nOJcWYN1aqD/P2NehyJAw2vyoZ9WMKXquLZHuRu0bEpz7meoDCbl2fH
        51VupSQ6LWgrWtYOYXLuPb1T0CfcGHs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-453-HwjOTzuOMpWfEJmaySG6Jw-1; Tue, 11 Oct 2022 09:33:38 -0400
X-MC-Unique: HwjOTzuOMpWfEJmaySG6Jw-1
Received: by mail-wr1-f69.google.com with SMTP id m20-20020adfa3d4000000b0022e2fa93dd1so3837399wrb.2
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 06:33:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BwKevNcEB0+6PdYWVWLw2/PB3wIw6Wy0YkYQ4wNAVj0=;
        b=sen6xmunGqI66phXs+aNjB4NSmIEGSuDtbh21JyMtatVpmvcDr11pdnzm19bkU9GIA
         pFuTjtir+NpikwEIzh/ET2QBtb3B8u3E/pB1vJTwaWGD8Mi9he5/XSHm2XkCmrWn29PV
         Q5n25JKzvUxBQyKsa3zJ3lgvC7vle0rRMcfgyCSPg2SOAyvjjTWVH7ZwyeOtJTYVgP0R
         5d8LyOFW1BeUH8Q0Zl1uYYtX2Q1iJZNy8nl0C727i7bDqFWVI6r4gbtF0xJtO8e3z9VN
         WrWI3emA5UKMfIIVogfDZ9u85b9z2DFf4tEdRsKb5hLydeTUC3576BWKD+OLPH9GGND8
         VSgw==
X-Gm-Message-State: ACrzQf3rmD+lkhCUPanQSNdGyxwNioA3AahlBWZ0rTF2q/PkLVODtxfO
        0nA13iKoDQ3TkRiymDqLGIetZXATHBGvcz6Hy+f2zqcGvh5NqGVIDOqTUMqGMN8F5Mcz2coTNOB
        WzLl3oNLmdqC7vxo2
X-Received: by 2002:a05:6000:1ac7:b0:22a:906d:3577 with SMTP id i7-20020a0560001ac700b0022a906d3577mr15668236wry.33.1665495217273;
        Tue, 11 Oct 2022 06:33:37 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4MpMpgCal3PxqjR56nvRaBtLRKYy4fCl5SVTEWnQnRK4qjV54S4ZhYo5vIpJqJ3QIheXf6og==
X-Received: by 2002:a05:6000:1ac7:b0:22a:906d:3577 with SMTP id i7-20020a0560001ac700b0022a906d3577mr15668220wry.33.1665495217054;
        Tue, 11 Oct 2022 06:33:37 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id l19-20020a05600c089300b003c5571c27a1sm9780854wmp.32.2022.10.11.06.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 06:33:36 -0700 (PDT)
Message-ID: <cd4812a98818cef28977e4f775dca5005df4f62c.camel@redhat.com>
Subject: Re: [PATCH net] openvswitch: add nf_ct_is_confirmed check before
 assigning the helper
From:   Paolo Abeni <pabeni@redhat.com>
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>, dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Yi-Hung Wei <yihung.wei@gmail.com>
Date:   Tue, 11 Oct 2022 15:33:35 +0200
In-Reply-To: <c5c9092a22a2194650222bffaf786902613deb16.1665085502.git.lucien.xin@gmail.com>
References: <c5c9092a22a2194650222bffaf786902613deb16.1665085502.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, 2022-10-06 at 15:45 -0400, Xin Long wrote:
> A WARN_ON call trace would be triggered when 'ct(commit, alg=helper)'
> applies on a confirmed connection:
> 
>   WARNING: CPU: 0 PID: 1251 at net/netfilter/nf_conntrack_extend.c:98
>   RIP: 0010:nf_ct_ext_add+0x12d/0x150 [nf_conntrack]
>   Call Trace:
>    <TASK>
>    nf_ct_helper_ext_add+0x12/0x60 [nf_conntrack]
>    __nf_ct_try_assign_helper+0xc4/0x160 [nf_conntrack]
>    __ovs_ct_lookup+0x72e/0x780 [openvswitch]
>    ovs_ct_execute+0x1d8/0x920 [openvswitch]
>    do_execute_actions+0x4e6/0xb60 [openvswitch]
>    ovs_execute_actions+0x60/0x140 [openvswitch]
>    ovs_packet_cmd_execute+0x2ad/0x310 [openvswitch]
>    genl_family_rcv_msg_doit.isra.15+0x113/0x150
>    genl_rcv_msg+0xef/0x1f0
> 
> which can be reproduced with these OVS flows:
> 
>   table=0, in_port=veth1,tcp,tcp_dst=2121,ct_state=-trk
>   actions=ct(commit, table=1)
>   table=1, in_port=veth1,tcp,tcp_dst=2121,ct_state=+trk+new
>   actions=ct(commit, alg=ftp),normal
> 
> The issue was introduced by commit 248d45f1e193 ("openvswitch: Allow
> attaching helper in later commit") where it somehow removed the check
> of nf_ct_is_confirmed before asigning the helper. This patch is to fix
> it by bringing it back.
> 
> Fixes: 248d45f1e193 ("openvswitch: Allow attaching helper in later commit")
> Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/openvswitch/conntrack.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
> index 4e70df91d0f2..6862475f0f88 100644
> --- a/net/openvswitch/conntrack.c
> +++ b/net/openvswitch/conntrack.c
> @@ -1015,7 +1015,8 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
>  		 * connections which we will commit, we may need to attach
>  		 * the helper here.
>  		 */
> -		if (info->commit && info->helper && !nfct_help(ct)) {
> +		if (!nf_ct_is_confirmed(ct) && info->commit &&
> +		    info->helper && !nfct_help(ct)) {
>  			int err = __nf_ct_try_assign_helper(ct, info->ct,
>  							    GFP_ATOMIC);
>  			if (err)

The patch LGTM, but it would be great if someone from the OVS side
could confirm this does not break existing use-case.

Thanks!

Paolo

