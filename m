Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673136982D4
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjBOSBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbjBOSBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:01:16 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC93F32CE7;
        Wed, 15 Feb 2023 10:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=1YBzz0ammUaJrlrKGRNYS5XjSgA8H5CFBcKMeCvMYco=;
        t=1676484073; x=1677693673; b=PQ5wsaJG72Ww/TeOFsuszgSak6FQHFKPNed+561Jg1oajNo
        LF+a1k6uWpXPLt0mVuHHOx2+QUgUpGqeXi5b9mztNkuKNHkhDNIQoF3JapU09gbpQgHuToBz9Djfl
        E1AHiAhbDz4flsHj0AkE3VDBv7x8qGMQWNlOxrrtbGU9piuYGfjkDHjIx7uhE4M2jBt5PYcKJgsHi
        +HOOygl0rV/1SrFpY1LKdJ5hOzLpxq2wVmXqXM48IAnEII8JZtoAAvUX5jAPIOp8cRVk0GRaTVP1E
        2j8368gNZpTsebOAKyg9xAMdq9ve28bbjRpvr+kM/GSKmj0ayiVtz/l5BULL8Vgg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pSM5g-00D9sy-0N;
        Wed, 15 Feb 2023 19:01:12 +0100
Message-ID: <6ad6708b124b50ff9ea64771b31d09e9168bfa17.camel@sipsolutions.net>
Subject: Re: [PATCH v7 1/4] mac80211_hwsim: add PMSR capability support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jaewan Kim <jaewan@google.com>, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-team@android.com, adelva@google.com
Date:   Wed, 15 Feb 2023 19:01:11 +0100
In-Reply-To: <20230207085400.2232544-2-jaewan@google.com>
References: <20230207085400.2232544-1-jaewan@google.com>
         <20230207085400.2232544-2-jaewan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-02-07 at 08:53 +0000, Jaewan Kim wrote:
> PMSR (a.k.a. peer measurement) is generalized measurement between two
> Wi-Fi devices. And currently FTM (a.k.a. fine time measurement or flight
> time measurement) is the one and only measurement. FTM is measured by
> RTT (a.k.a. round trip time) of packets between two Wi-Fi devices.
>=20
> This change allows mac80211_hwsim to be configured with PMSR capability.
> The capability is mandatory to accept incoming PMSR request because
> nl80211_pmsr_start() ignores incoming the request without the PMSR
> capability.
>=20
> This change adds HWSIM_ATTR_PMSR_SUPPORT, which is used to set PMSR
> capability when creating a new radio. To send extra details,
> HWSIM_ATTR_PMSR_SUPPORT can have nested PMSR capability attributes define=
d
> in the nl80211.h. Data format is the same as cfg80211_pmsr_capabilities.
>=20
> If HWSIM_ATTR_PMSR_SUPPORT is specified, mac80211_hwsim builds
> cfg80211_pmsr_capabilities and sets wiphy.pmsr_capa.

I feel kind of bad for even still commenting on v7 already ... :)

Sorry I didn't pay much attention to this before.


> +static const struct nla_policy
> +hwsim_ftm_capa_policy[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1] =3D {

This feels a bit iffy to have here, but I guess it's better that
defining new attributes for all this over and over again.

> +	[NL80211_PMSR_FTM_CAPA_ATTR_ASAP] =3D { .type =3D NLA_FLAG },
> +	[NL80211_PMSR_FTM_CAPA_ATTR_NON_ASAP] =3D { .type =3D NLA_FLAG },
> +	[NL80211_PMSR_FTM_CAPA_ATTR_REQ_LCI] =3D { .type =3D NLA_FLAG },
> +	[NL80211_PMSR_FTM_CAPA_ATTR_REQ_CIVICLOC] =3D { .type =3D NLA_FLAG },
> +	[NL80211_PMSR_FTM_CAPA_ATTR_PREAMBLES] =3D { .type =3D NLA_U32 },
> +	[NL80211_PMSR_FTM_CAPA_ATTR_BANDWIDTHS] =3D { .type =3D NLA_U32 },
> +	[NL80211_PMSR_FTM_CAPA_ATTR_MAX_BURSTS_EXPONENT] =3D NLA_POLICY_MAX(NLA=
_U8, 15),
> +	[NL80211_PMSR_FTM_CAPA_ATTR_MAX_FTMS_PER_BURST] =3D NLA_POLICY_MAX(NLA_=
U8, 31),

Could add some line-breaks where it's easy to stay below 80 columns. Not
a hard rule, but still reads nicer.

> +	if (param->pmsr_capa)
> +		ret =3D cfg80211_send_pmsr_capa(param->pmsr_capa, skb);

I'm not a fan of exporting this function to drivers - it feels odd. It's
also not really needed, since once the new radio exists the user can
query it through cfg80211. I'd just remove this part, along with the
changes in include/ and net/

> @@ -4445,6 +4481,8 @@ static int mac80211_hwsim_new_radio(struct genl_inf=
o *info,
>  			      NL80211_EXT_FEATURE_MULTICAST_REGISTRATIONS);
>  	wiphy_ext_feature_set(hw->wiphy,
>  			      NL80211_EXT_FEATURE_BEACON_RATE_LEGACY);
> +	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_ENABLE_FTM_RESPOND=
ER);
> +
>=20

no need for the extra blank line.

> +static int parse_ftm_capa(const struct nlattr *ftm_capa, struct cfg80211=
_pmsr_capabilities *out,
> +			  struct genl_info *info)

That line also got really long, unnecessarily.

> +{
> +	struct nlattr *tb[NL80211_PMSR_FTM_CAPA_ATTR_MAX + 1];
> +	int ret =3D nla_parse_nested(tb, NL80211_PMSR_FTM_CAPA_ATTR_MAX,
> +				   ftm_capa, hwsim_ftm_capa_policy, NULL);

should have a blank line here I guess.

> +static int parse_pmsr_capa(const struct nlattr *pmsr_capa, struct cfg802=
11_pmsr_capabilities *out,
> +			   struct genl_info *info)
> +{
> +	struct nlattr *tb[NL80211_PMSR_ATTR_MAX + 1];
> +	struct nlattr *nla;
> +	int size;
> +	int ret =3D nla_parse_nested(tb, NL80211_PMSR_ATTR_MAX, pmsr_capa,
> +				   hwsim_pmsr_capa_policy, NULL);
> +	if (ret) {

same here for both of those comments

> =20
> +	if (info->attrs[HWSIM_ATTR_PMSR_SUPPORT]) {
> +		struct cfg80211_pmsr_capabilities *pmsr_capa =3D
> +			kmalloc(sizeof(struct cfg80211_pmsr_capabilities), GFP_KERNEL);

sizeof(*pmsr_capa), also makes that line a lot shorter

> + * @HWSIM_ATTR_PMSR_SUPPORT: claim peer measurement support

This should probably explain that it's nested, and what should be inside
of it.

johannes
