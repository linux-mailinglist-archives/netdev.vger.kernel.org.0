Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD576982F0
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjBOSHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:07:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjBOSHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:07:51 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E9B2683;
        Wed, 15 Feb 2023 10:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=OF34kHCyf/QBRLjypk4iO0U7q2F9jr67DdtJ7dKmxsI=;
        t=1676484469; x=1677694069; b=LszubTTG1UIEg16jzif4y4TsYY8v9urN6Ckp64Rbd/KSYq6
        WpHIrrqbTtpT9c03bNnDMYh1/s9yyQWuEKWzON/AKyrfRIMuyNAQHHiGygetKIvzgSVRk1UUH+it8
        aQFKIKbqqLtH748ct+xOl5POObEb7SS5nGqVSTVE9i4I9LO45lT0BZ0BVLSZ3/jXzkVHAFPajaTAs
        1dihyQLOEClEyv8r/BCDg9DpyEt6X6GQEKu1CuCqA9WrhRMxBInFW/APl3Ubmi34JQhNQKBZqSOYu
        Fa/3GSIT1iqHVgN4PX8Wtdvij0dkMVuDbRIgilCtaLmKoizHddgqTO1XWqMySbKQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pSMC4-00DA4D-03;
        Wed, 15 Feb 2023 19:07:48 +0100
Message-ID: <fbe6f8eb820b29f0cc932a63ad84253d0cef93c3.camel@sipsolutions.net>
Subject: Re: [PATCH v7 2/4] mac80211_hwsim: add PMSR request support via
 virtio
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jaewan Kim <jaewan@google.com>, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-team@android.com, adelva@google.com
Date:   Wed, 15 Feb 2023 19:07:47 +0100
In-Reply-To: <20230207085400.2232544-3-jaewan@google.com>
References: <20230207085400.2232544-1-jaewan@google.com>
         <20230207085400.2232544-3-jaewan@google.com>
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
>=20
> =20
> +static int mac80211_hwsim_send_pmsr_ftm_request_peer(struct sk_buff *msg=
,
> +						     struct cfg80211_pmsr_ftm_request_peer *request)

this ...

> +{
> +	struct nlattr *ftm;
> +
> +	if (!request->requested)
> +		return -EINVAL;
> +
> +	ftm =3D nla_nest_start(msg, NL80211_PMSR_TYPE_FTM);
> +	if (!ftm)
> +		return -ENOBUFS;
> +
> +	if (nla_put_u32(msg, NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE, request->pream=
ble))
> +		return -ENOBUFS;
> +
> +	if (nla_put_u16(msg, NL80211_PMSR_FTM_REQ_ATTR_BURST_PERIOD, request->b=
urst_period))
> +		return -ENOBUFS;

and this ... etc ...

also got some really long lines that could easily be broken

> +	chandef =3D nla_nest_start(msg, NL80211_PMSR_PEER_ATTR_CHAN);
> +	if (!chandef)
> +		return -ENOBUFS;
> +
> +	err =3D cfg80211_send_chandef(msg, &request->chandef);
> +	if (err)
> +		return err;

So this one I think I'll let you do with the export and all, because
that's way nicer than duplicating the code, and it's clearly necessary.

> +static int mac80211_hwsim_send_pmsr_request(struct sk_buff *msg,
> +					    struct cfg80211_pmsr_request *request)
> +{
> +	int err;
> +	struct nlattr *pmsr =3D nla_nest_start(msg, NL80211_ATTR_PEER_MEASUREME=
NTS);

I'm not going to complain _too_ much about this, but all this use of
nl80211 attributes better be thoroughly documented in the header file.

> + * @HWSIM_CMD_START_PMSR: start PMSR

That sounds almost like it's a command ("start PMSR") but really it's a
notification/event as far as hwsim is concerned, so please document
that.

> + * @HWSIM_ATTR_PMSR_REQUEST: peer measurement request

and please document the structure of the request that userspace will get
(and how it should respond?)

> +++ b/include/net/cfg80211.h
> @@ -938,6 +938,16 @@ int cfg80211_chandef_dfs_required(struct wiphy *wiph=
y,
>  				  const struct cfg80211_chan_def *chandef,
>  				  enum nl80211_iftype iftype);
> =20
> +/**
> + * cfg80211_send_chandef - sends the channel definition.
> + * @msg: the msg to send channel definition
> + * @chandef: the channel definition to check
> + *
> + * Returns: 0 if sent the channel definition to msg, < 0 on error
> + **/

That last line should just be */

> +int cfg80211_send_chandef(struct sk_buff *msg, const struct cfg80211_cha=
n_def *chandef);

I think it'd be better if you exported it as nl80211_..., since it
really is just a netlink thing, not cfg80211 functionality.

It would also be good, IMHO, to split this part out into a separate
patch saying that e.g. hwsim might use it like you do here, or even that
vendor netlink could use it where needed.

johannes
