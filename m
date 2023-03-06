Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D876ACF63
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 21:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjCFUpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 15:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjCFUpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 15:45:22 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2812A65124;
        Mon,  6 Mar 2023 12:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=73dv3lO8tfv0IBqr2xR7/JEstuoo/6DIYCe6oAFCbjw=;
        t=1678135521; x=1679345121; b=GNswLlE8U3d/r37WIKAM1jNjWz9cMm9Vg+5yqmlB9lQdllS
        YECwr14OEaoRQimsn9Lclfkfof+wz9GzCz2scC3GRkRSNgMXD26jQGm7YU3OEiJLg2JjYc8NVHaWE
        XetZf7b7o68S19pi/dW9rEsNCnfn+USVjNt/LSFhn2l9Nf3M/qBjK03rLjs9qrbE72Is1ItRlG67H
        bawZS25BI9ndZw+zb2RT9b4MKxE6zY5BbxUt1rl/ApHUpUxuf8g49uQqFoYPshfMdvu9LJTIOocpp
        BPzFCiwvLSZ4T7FdiaXzLjd6N/pHUHpeiTozusSdvGOeXBunsncOVCf2VUyWPwsw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pZHht-00DbfI-1k;
        Mon, 06 Mar 2023 21:45:17 +0100
Message-ID: <582bea54cc5833137a2f8b7a375484b1656ed761.camel@sipsolutions.net>
Subject: Re: [PATCH v8 3/5] mac80211_hwsim: add PMSR request support via
 virtio
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Simon Horman <simon.horman@corigine.com>,
        Jaewan Kim <jaewan@google.com>
Cc:     gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com, adelva@google.com
Date:   Mon, 06 Mar 2023 21:45:16 +0100
In-Reply-To: <ZAYe4oATHMdqi/H9@corigine.com>
References: <20230302160310.923349-1-jaewan@google.com>
         <20230302160310.923349-4-jaewan@google.com> <ZAYe4oATHMdqi/H9@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
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

On Mon, 2023-03-06 at 18:12 +0100, Simon Horman wrote:
>=20
> > =20
> > +static int mac80211_hwsim_send_pmsr_ftm_request_peer(struct sk_buff *m=
sg,
> > +						     struct cfg80211_pmsr_ftm_request_peer *request)
> > +{
> > +	struct nlattr *ftm;
> > +
> > +	if (!request->requested)
> > +		return -EINVAL;
> > +
> > +	ftm =3D nla_nest_start(msg, NL80211_PMSR_TYPE_FTM);
> > +	if (!ftm)
> > +		return -ENOBUFS;
> > +
> > +	if (nla_put_u32(msg, NL80211_PMSR_FTM_REQ_ATTR_PREAMBLE, request->pre=
amble))
>=20
> nit: I suspect that you need to invoke nla_nest_cancel() in
>      error paths to unwind nla_nest_start() calls.

The entire message is discarded if that happens, I think? Doesn't seem
all that necessary in that case.

johannes
