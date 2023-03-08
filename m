Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCBF6B007E
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 09:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjCHIHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 03:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjCHIHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 03:07:19 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F53DAF29E;
        Wed,  8 Mar 2023 00:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=HiLTGh4IUiBfgFWIqr2+yw+o/vwqYzP3id5WiIDWHCQ=;
        t=1678262817; x=1679472417; b=EPifv+R7Oh5o/gaxoj5iOCS9P/RuG73Uesms3AJf1ubN3Mf
        7PBAabuuDBkewRGMCBKhc6uCcICcuS1MNTbKl5E3zHQPxw+a0nXxNXvHCqexNMhDnkH+1e4A0xYe3
        fLxCW0sb2/4Ps8CEm/edF1XXm7H031A1jmPKqQk4/buZULsI/hAY0S/5kY5Tiz+uLLQhRlbNPBy5a
        8B33yC31CLAAVw4SunfFG01h5HvKl6ruZoklfIkDRBUJxjfat4zmbF+3B2l3uqPQAhCFnPb+55BP/
        0TDs0aT6epmAW2UiWG1fxiQyRrMnoc2koQsMaoDGqHhXxY7R5WjPYn8zz5jdNf6w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pZop2-00F8Xo-1s;
        Wed, 08 Mar 2023 09:06:52 +0100
Message-ID: <51c2b615d848c227edae52cc07df334695c7f856.camel@sipsolutions.net>
Subject: Re: [PATCH v8 1/5] mac80211_hwsim: add PMSR capability support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jaewan Kim <jaewan@google.com>,
        Simon Horman <simon.horman@corigine.com>
Cc:     gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com, adelva@google.com
Date:   Wed, 08 Mar 2023 09:06:51 +0100
In-Reply-To: <CABZjns6=CM7qYPEDnhP=ZpJqMaA=yWw6vSMPOTRnk87PsYY4yg@mail.gmail.com>
References: <20230302160310.923349-1-jaewan@google.com>
         <20230302160310.923349-2-jaewan@google.com> <ZAYa4oteaDVPGOLp@corigine.com>
         <CABZjns6=CM7qYPEDnhP=ZpJqMaA=yWw6vSMPOTRnk87PsYY4yg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-03-08 at 08:00 +0000, Jaewan Kim wrote:
> >=20
> > > +static int parse_pmsr_capa(const struct nlattr *pmsr_capa, struct cf=
g80211_pmsr_capabilities *out,
> > > +                        struct genl_info *info)
> > > +{
> > > +     struct nlattr *tb[NL80211_PMSR_ATTR_MAX + 1];
> > > +     struct nlattr *nla;
> > > +     int size;
> >  +      int ret =3D nla_parse_nested(tb, NL80211_PMSR_ATTR_MAX, pmsr_ca=
pa,
> > > +                                hwsim_pmsr_capa_policy, NULL);
> > > +
> > > +     if (ret) {
> > > +             NL_SET_ERR_MSG_ATTR(info->extack, pmsr_capa, "malformed=
 PMSR capability");
> > > +             return -EINVAL;
> > > +     }
> > > +
> > > +     if (tb[NL80211_PMSR_ATTR_MAX_PEERS])
> > > +             out->max_peers =3D nla_get_u32(tb[NL80211_PMSR_ATTR_MAX=
_PEERS]);
> > > +     out->report_ap_tsf =3D !!tb[NL80211_PMSR_ATTR_REPORT_AP_TSF];
> > > +     out->randomize_mac_addr =3D !!tb[NL80211_PMSR_ATTR_RANDOMIZE_MA=
C_ADDR];
> > > +
> > > +     if (!tb[NL80211_PMSR_ATTR_TYPE_CAPA]) {
> > > +             NL_SET_ERR_MSG_ATTR(info->extack, tb[NL80211_PMSR_ATTR_=
TYPE_CAPA],
> > > +                                 "malformed PMSR type");
> > > +             return -EINVAL;
> > > +     }
> > > +
> > > +     nla_for_each_nested(nla, tb[NL80211_PMSR_ATTR_TYPE_CAPA], size)=
 {
> > > +             switch (nla_type(nla)) {
> > > +             case NL80211_PMSR_TYPE_FTM:
> > > +                     parse_ftm_capa(nla, out, info);
> > > +                     break;
> > > +             default:
> > > +                     WARN_ON(1);
> >=20
> > WARN_ON doesn't seem right here. I suspect that the following is more f=
itting.
> >=20
> >                 NL_SET_ERR_MSG_ATTR(...);
> >                 return -EINVAL;
> >=20
>=20
> Not using NL_SET_ERR_MSG_ATTR(...) is intended to follow the pattern
> of net/wireless/pmsr.c,
> where unknown type isn't considered as an error.

NL80211_PMSR_ATTR_TYPE_CAPA is normally NLA_REJECT (not sent by
userspace), you just use it here for the hwsim capabilities which makes
sense, but it feels better to just reject unknown types.

If you're thinking of actually using it we still have in pmsr.c this
code:

        nla_for_each_nested(treq, req[NL80211_PMSR_REQ_ATTR_DATA], rem) {
                switch (nla_type(treq)) {
                case NL80211_PMSR_TYPE_FTM:
                        err =3D pmsr_parse_ftm(rdev, treq, out, info);
                        break;
                default:
                        NL_SET_ERR_MSG_ATTR(info->extack, treq,
                                            "unsupported measurement type")=
;
                        err =3D -EINVAL;
                }


johannes
