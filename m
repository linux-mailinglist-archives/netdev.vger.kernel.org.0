Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78C736ED384
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 19:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbjDXRbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 13:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjDXRbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 13:31:38 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F89A49D0;
        Mon, 24 Apr 2023 10:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=vQmgYfjUWtANRFg4R17wIImSSlnTF/Qkytux67BSXAE=;
        t=1682357497; x=1683567097; b=rSsDP1Vki1ipMkSTTgg3gDDovnHzQ378U9Jb92Y2XRgi40K
        5uLBmwA7vZSOkthMVihKKnh+x5HA0nV/zZ2HBI/wfCh95nstx0qdN3r57kWU3oe9akt/RYNFbOwVU
        SfajWuecLY0XKT+Gt+nkV74le5Yu1QAnW/2Jw6IU2JDyppfk3bZTydl1N0dKDRiNWEsv57Wj3cKnw
        Bng19adTzVWB+FnW5EAKye/lNTyDz8HBfQcDQv9bgrmX9Z9OSks2paBoWeruumtZTdJPCK/4+KjsG
        5fWnQZDQEg89IB1OKQ9OQYe/+VFzWHkI3zqxgkrHnga2zrNmBFTsqzr8YMjcmc8g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pr028-007KRc-0Z;
        Mon, 24 Apr 2023 19:31:24 +0200
Message-ID: <fffb3e6ad76a26a9633728501b5d606864235e65.camel@sipsolutions.net>
Subject: Re: [PATCH 09/22] wifi: iwlwifi: Use alloc_ordered_workqueue() to
 create ordered workqueues
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Tejun Heo <tj@kernel.org>, jiangshanlai@gmail.com
Cc:     linux-kernel@vger.kernel.org, kernel-team@meta.com,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Avraham Stern <avraham.stern@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        "Haim, Dreyfuss" <haim.dreyfuss@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Mon, 24 Apr 2023 19:31:22 +0200
In-Reply-To: <20230421025046.4008499-10-tj@kernel.org>
References: <20230421025046.4008499-1-tj@kernel.org>
         <20230421025046.4008499-10-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-04-20 at 16:50 -1000, Tejun Heo wrote:
> This patch series audits all callsites that create an UNBOUND workqueue w=
/
> @max_active=3D=3D1 and converts them to alloc_ordered_workqueue() as nece=
ssary.
>=20
> WHAT TO LOOK FOR
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> The conversions are from
>=20
>   alloc_workqueue(WQ_UNBOUND | flags, 1, args..)
>=20
> to
>=20
>   alloc_ordered_workqueue(flags, args...)
>=20
> which don't cause any functional changes. If you know that fully ordered
> execution is not ncessary, please let me know. I'll drop the conversion a=
nd
> instead add a comment noting the fact to reduce confusion while conversio=
n
> is in progress.

This workqueue only has a single work struct queued on it, I'm not
_entirely_ sure why there's even a separate workqueue (possibly for
priority reasons etc.), but surely with just a single work struct, order
cannot really matter.

johannes

