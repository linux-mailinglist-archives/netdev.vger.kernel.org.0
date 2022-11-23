Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78755635AE7
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 12:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237279AbiKWLDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 06:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237272AbiKWLCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 06:02:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E5E766E
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669200974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l54HYus/cxyQ1Wo3s9Ar8I4E1CMWTPLpcC1cJGSxmds=;
        b=afbo0mLzKaM6MGJyfZdI5XLd8fGKTVSS9mqSSC6mAqemkHSokBEB0GnwUcCOo7v8HXRY/M
        mleGpOVdMgvnxzku1XFeNeQNNUgxB85jfdj+1kXENAywTIKDlFqclJuW5+Pf0+Sdkmk5Li
        fsF6REB6HNsTEqOa+wVVe0f5Rul2TsM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-600-wJKH0m6ZNGG8ucotNlQPlA-1; Wed, 23 Nov 2022 05:56:13 -0500
X-MC-Unique: wJKH0m6ZNGG8ucotNlQPlA-1
Received: by mail-ej1-f72.google.com with SMTP id hp16-20020a1709073e1000b007adf5a83df7so9688853ejc.1
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:56:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l54HYus/cxyQ1Wo3s9Ar8I4E1CMWTPLpcC1cJGSxmds=;
        b=uGP7z5okWYtPiUliSReaOiZJXWXINMLlgosuexr6v2OZGoPd+yopGPjK/XPDTLY3ze
         cQMfUjeWtASfeUzGKUZbi8OHxeQ7VU8WHRyGVFmHocGf+a5UnpBrACaQ+IWiRcsOQbsl
         x37Ag8LbDMMLcoagw0SMToItMyNK8HctP+ajujJF2oWH4oBMDAV2cbTD9ZKtqoco83wv
         01QldHh0FQQ9sqiflQbh5qWJfz3timTYgfD3Pij6gXD7m5Pz6SsG7NR4vSn5DP5VoCBu
         9LeDoHinWr2Axt2w+05ANtl/Br4MroksGxKqYe4FOSgdjWb6q6eRqeIcaOll8mRXg55N
         A0Cg==
X-Gm-Message-State: ANoB5pmSMaTKu8/QjUYynkzU8TCXiK1j8k/JHLn+MKBFhJ0eLF/lFIxL
        H/prI1CAnmUzNZScJs0ECB1B2FAlSwFP8Cns4WAFnH1Xk23ERFF98rN5jPf4w//ESt+qiAQ1kGu
        SlCzlgt1+BF5MngCd
X-Received: by 2002:aa7:c50b:0:b0:469:d36e:3213 with SMTP id o11-20020aa7c50b000000b00469d36e3213mr8702519edq.206.1669200971917;
        Wed, 23 Nov 2022 02:56:11 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6EEtGIUsh0TaapPYpilssn23lE+M39otB8rkxJfLR+C6DChFDG0s9rP78FjGQP7/iYQuETcw==
X-Received: by 2002:aa7:c50b:0:b0:469:d36e:3213 with SMTP id o11-20020aa7c50b000000b00469d36e3213mr8702504edq.206.1669200971611;
        Wed, 23 Nov 2022 02:56:11 -0800 (PST)
Received: from [10.39.192.66] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id p22-20020a170906229600b0077a8fa8ba55sm7141789eja.210.2022.11.23.02.56.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Nov 2022 02:56:10 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Pravin B Shelar <pshelar@ovn.org>, netdev@vger.kernel.org
Cc:     Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>, dev@openvswitch.org
Subject: Re: Patch
 "openvswitch: Fix Frame-size larger than 1024 bytes warning" not correct.
Date:   Wed, 23 Nov 2022 11:56:10 +0100
X-Mailer: MailMate (1.14r5927)
Message-ID: <668B8E04-CD93-4E37-B121-A7F9DBCE4088@redhat.com>
In-Reply-To: <9FD6F4CD-4F41-4350-B217-4EFE40E347E2@redhat.com>
References: <9FD6F4CD-4F41-4350-B217-4EFE40E347E2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pravin,

Any update feedback on this?

//Eelco


On 15 Nov 2022, at 17:16, Eelco Chaudron wrote:

> Hi Pravin,
>
> It looks like a previous fix you made, 190aa3e77880 ("openvswitch: Fix =
Frame-size larger than 1024 bytes warning."), is breaking stuff. With thi=
s change, the actual flow lookup, ovs_flow_tbl_lookup(), is done using a =
masked key, where it should be an unmasked key. This is maybe more clear =
if you take a look at the diff for the ufid addition, 74ed7ab9264c ("open=
vswitch: Add support for unique flow IDs.").
>
> Just reverting the change gets rid of the problem, but it will re-intro=
duce the larger stack size. It looks like we either have it on the stack =
or dynamically allocate it each time. Let me know if you have any other c=
lever fix ;)
>
> We found this after debugging some customer-specific issue. More detail=
s are in the following OVS patch, https://patchwork.ozlabs.org/project/op=
envswitch/list/?series=3D328315
>
> Cheers,
>
> Eelco
>
>
> FYI the working revers:
>
>
>    Revert "openvswitch: Fix Frame-size larger than 1024 bytes warning."=

>
>     This reverts commit 190aa3e77880a05332ea1ccb382a51285d57adb5.
>
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 861dfb8daf4a..660d5fdd9b28 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -948,6 +948,7 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, st=
ruct genl_info *info)
>         struct sw_flow_mask mask;
>         struct sk_buff *reply;
>         struct datapath *dp;
> +       struct sw_flow_key key;
>         struct sw_flow_actions *acts;
>         struct sw_flow_match match;
>         u32 ufid_flags =3D ovs_nla_get_ufid_flags(a[OVS_FLOW_ATTR_UFID_=
FLAGS]);
> @@ -975,24 +976,20 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, =
struct genl_info *info)
>         }
>
>         /* Extract key. */
> -       ovs_match_init(&match, &new_flow->key, false, &mask);
> +       ovs_match_init(&match, &key, true, &mask);
>         error =3D ovs_nla_get_match(net, &match, a[OVS_FLOW_ATTR_KEY],
>                                   a[OVS_FLOW_ATTR_MASK], log);
>         if (error)
>                 goto err_kfree_flow;
>
> +       ovs_flow_mask_key(&new_flow->key, &key, true, &mask);
> +
>         /* Extract flow identifier. */
>         error =3D ovs_nla_get_identifier(&new_flow->id, a[OVS_FLOW_ATTR=
_UFID],
> -                                      &new_flow->key, log);
> +                                      &key, log);
>         if (error)
>                 goto err_kfree_flow;
>
> -       /* unmasked key is needed to match when ufid is not used. */
> -       if (ovs_identifier_is_key(&new_flow->id))
> -               match.key =3D new_flow->id.unmasked_key;
> -
> -       ovs_flow_mask_key(&new_flow->key, &new_flow->key, true, &mask);=

> -
>         /* Validate actions. */
>         error =3D ovs_nla_copy_actions(net, a[OVS_FLOW_ATTR_ACTIONS],
>                                      &new_flow->key, &acts, log);
> @@ -1019,7 +1016,7 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, =
struct genl_info *info)
>         if (ovs_identifier_is_ufid(&new_flow->id))
>                 flow =3D ovs_flow_tbl_lookup_ufid(&dp->table, &new_flow=
->id);
>         if (!flow)
> -               flow =3D ovs_flow_tbl_lookup(&dp->table, &new_flow->key=
);
> +               flow =3D ovs_flow_tbl_lookup(&dp->table, &key);
>         if (likely(!flow)) {
>                 rcu_assign_pointer(new_flow->sf_acts, acts);

