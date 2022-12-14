Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE50764CCF9
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 16:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238780AbiLNPVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 10:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238760AbiLNPVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 10:21:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6AD17AB8
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 07:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671031225;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZpmeviEDsjlombFkmkQNYIYSEJkAvCmgJKkn5T5ZVaQ=;
        b=bhzAwLpOnuwDbidNZgIxfQqXpwAO03JiSsWuuqY4q1o0cvuG11GcvbxBqsWzpQxYHZJlm+
        GbZqncqvYwpAs11o1iRfFNSRZfBunsdBQqe1hADmTJk/zHCoDjVvs4IN4Uambl2WKHAMeF
        E5WcKMnykLKXV3ogk3Qtt0gA9xhpEts=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-180-Vs8vMVFvOYqT4tIxzUNF9Q-1; Wed, 14 Dec 2022 10:20:24 -0500
X-MC-Unique: Vs8vMVFvOYqT4tIxzUNF9Q-1
Received: by mail-ed1-f70.google.com with SMTP id j6-20020a05640211c600b0046d6960b266so9667682edw.6
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 07:20:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZpmeviEDsjlombFkmkQNYIYSEJkAvCmgJKkn5T5ZVaQ=;
        b=viUA5f2uVPbc6zcC2dxJCpDHgRemJg1WwTvGzsFA/6vM4FjymrqZF0EQlxBw1pbia1
         N2Z5w7S0gmdQ/DOalmSzJtYesHWX/aBhE4oAd+zYNlNDNPKdDI4aToeMsKAlsOht3zWZ
         DxV35c4q7Opa1yu0xJ8lYwsGIyLwsJnuPgMx4g1Odg5ExvhE5CmrqUYPLJD72zJ9c8wP
         GCk0ukE2YGLJkr0MfngWe5e7FywIJHLf9x8G4ByOOyI0srITROAxnWu3yZ3ID9XvSMfs
         bOFZCkVfmKUDvkqm7DrT7JbggsUUP27/UnPxkj1xgCkq0vmIkqNcXxP5nJw/6y+zms6X
         aJFQ==
X-Gm-Message-State: ANoB5pnQiW8aVfAC2d7fju9m1ey9osnEwjsYpBOdNegosY25TLend+9f
        TqG7IuD+vu5roS5mdB1A5we8mbo2ZG0A8abeV0LIt3xyf8HoJEywpcwILpO1eRc1YpH8cTbfVzY
        2R7bEJCmqsddX1WPR9hT2qHV6BsSLYPwvzsBRUAJV7XnTUbzOLTHruDK2p+f1wDbufbKb
X-Received: by 2002:a17:907:c716:b0:7c0:e7a7:50b with SMTP id ty22-20020a170907c71600b007c0e7a7050bmr22007745ejc.48.1671031222651;
        Wed, 14 Dec 2022 07:20:22 -0800 (PST)
X-Google-Smtp-Source: AA0mqf44F7O3IeEfqvrZymGUVrTWSQAVCQMCwtJngGT0EkZWZ4mKwFzkMGugCg4GIPZkrGkiuElSTA==
X-Received: by 2002:a17:907:c716:b0:7c0:e7a7:50b with SMTP id ty22-20020a170907c71600b007c0e7a7050bmr22007723ejc.48.1671031222379;
        Wed, 14 Dec 2022 07:20:22 -0800 (PST)
Received: from [10.39.192.172] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id ku11-20020a170907788b00b007adaca75bd0sm6068237ejc.179.2022.12.14.07.20.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Dec 2022 07:20:21 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dev@openvswitch.org, i.maximets@ovn.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net
Subject: Re: [ovs-dev] [PATCH net] openvswitch: Fix flow lookup to use
 unmasked key
Date:   Wed, 14 Dec 2022 16:20:21 +0100
X-Mailer: MailMate (1.14r5930)
Message-ID: <B9AEC3C3-180D-45DB-84C2-B910C65FFA5C@redhat.com>
In-Reply-To: <167103089716.302975.6689490142121100905.stgit@ebuild>
References: <167103089716.302975.6689490142121100905.stgit@ebuild>
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



On 14 Dec 2022, at 16:14, Eelco Chaudron wrote:

> The commit mentioned below causes the ovs_flow_tbl_lookup() function
> to be called with the masked key. However, it's supposed to be called
> with the unmasked key.
>
> This change reverses the commit below, but rather than having the key
> on the stack, it's allocated.
>
> Fixes: 190aa3e77880 ("openvswitch: Fix Frame-size larger than 1024 byte=
s warning.")
>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Please ignore this version, as I sent out out without doing a stg refresh=
 :(

> ---
>  net/openvswitch/datapath.c |   25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
>
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index 861dfb8daf4a..23b233caa7fd 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -948,6 +948,7 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, st=
ruct genl_info *info)
>  	struct sw_flow_mask mask;
>  	struct sk_buff *reply;
>  	struct datapath *dp;
> +	struct sw_flow_key *key;
>  	struct sw_flow_actions *acts;
>  	struct sw_flow_match match;
>  	u32 ufid_flags =3D ovs_nla_get_ufid_flags(a[OVS_FLOW_ATTR_UFID_FLAGS]=
);
> @@ -975,24 +976,26 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, =
struct genl_info *info)
>  	}
>
>  	/* Extract key. */
> -	ovs_match_init(&match, &new_flow->key, false, &mask);
> +	key =3D kzalloc(sizeof(*key), GFP_KERNEL);
> +	if (!key) {
> +		error =3D -ENOMEN;
> +		goto err_kfree_key;
> +	}
> +
> +	ovs_match_init(&match, key, false, &mask);
>  	error =3D ovs_nla_get_match(net, &match, a[OVS_FLOW_ATTR_KEY],
>  				  a[OVS_FLOW_ATTR_MASK], log);
>  	if (error)
>  		goto err_kfree_flow;
>
> +	ovs_flow_mask_key(&new_flow->key, key, true, &mask);
> +
>  	/* Extract flow identifier. */
>  	error =3D ovs_nla_get_identifier(&new_flow->id, a[OVS_FLOW_ATTR_UFID]=
,
> -				       &new_flow->key, log);
> +				       key, log);
>  	if (error)
>  		goto err_kfree_flow;
>
> -	/* unmasked key is needed to match when ufid is not used. */
> -	if (ovs_identifier_is_key(&new_flow->id))
> -		match.key =3D new_flow->id.unmasked_key;
> -
> -	ovs_flow_mask_key(&new_flow->key, &new_flow->key, true, &mask);
> -
>  	/* Validate actions. */
>  	error =3D ovs_nla_copy_actions(net, a[OVS_FLOW_ATTR_ACTIONS],
>  				     &new_flow->key, &acts, log);
> @@ -1019,7 +1022,7 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, =
struct genl_info *info)
>  	if (ovs_identifier_is_ufid(&new_flow->id))
>  		flow =3D ovs_flow_tbl_lookup_ufid(&dp->table, &new_flow->id);
>  	if (!flow)
> -		flow =3D ovs_flow_tbl_lookup(&dp->table, &new_flow->key);
> +		flow =3D ovs_flow_tbl_lookup(&dp->table, key);
>  	if (likely(!flow)) {
>  		rcu_assign_pointer(new_flow->sf_acts, acts);
>
> @@ -1089,6 +1092,8 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, =
struct genl_info *info)
>
>  	if (reply)
>  		ovs_notify(&dp_flow_genl_family, reply, info);
> +
> +	kfree(key);
>  	return 0;
>
>  err_unlock_ovs:
> @@ -1098,6 +1103,8 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, =
struct genl_info *info)
>  	ovs_nla_free_flow_actions(acts);
>  err_kfree_flow:
>  	ovs_flow_free(new_flow, false);
> +err_kfree_key:
> +	kfree(key);
>  error:
>  	return error;
>  }
>
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev

