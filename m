Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956586CF29F
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 21:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjC2TA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 15:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjC2TA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 15:00:56 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504082D55;
        Wed, 29 Mar 2023 12:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=V3nhz2pvP7h7Cz23MObcCMnl1WaF8f98/d7AXl1BRts=;
        t=1680116455; x=1681326055; b=ALQfJZG/1sZhH4NBN/nX2YOZUb8Zjalnndhc5NhMUuSMSkZ
        U9ycLOm/tY7abL9VmjMEzS+M77hJN/MziGjX1VR134c2bNiMdAbB0yWuvOJ5qrfs86OUgRCDYS+PN
        AxImBDwcn/WAfx7UN3sAKnjjK+mctuRttGRIF7F0DOnHuOwmFmqqDm57534GRoxUEqdCI2ALe7l5U
        ldG+7aZuJPjYY0gYk2g5RJCqxx2hizP8xSfrN9+uz5AvEw8In4VBaLcCzhZ19oJF2qnB8XZgSFfhi
        Cs4nflVaTCuDjV8BgZTa8uq+p4h2JJGI3I49T77BfAoO39oxE3RTtqil6UZv0bwg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1phb2O-000CaR-0l;
        Wed, 29 Mar 2023 21:00:48 +0200
Message-ID: <465e2312486da2c68f26811884474d080e906d87.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next] wifi: iwlwifi: mvm: Avoid 64-bit division
 in iwl_mvm_get_crosstimestamp_fw()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Nathan Chancellor <nathan@kernel.org>, gregory.greenman@intel.com,
        kvalo@kernel.org, trix@redhat.com, avraham.stern@intel.com,
        krishnanand.prabhu@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev,
        Arnd Bergmann <arnd@arndb.de>,
        "kernelci.org bot" <bot@kernelci.org>,
        Craig Topper <craig.topper@sifive.com>
Date:   Wed, 29 Mar 2023 21:00:47 +0200
In-Reply-To: <CAKwvOdnQ9feXGYV2CUyVwg-FNAOmb4HBmDxMg243v28DzSfLuA@mail.gmail.com>
References: <20230329-iwlwifi-ptp-avoid-64-bit-div-v1-1-ad8db8d66bc2@kernel.org>
         <9058a032c177e9b04adbf944ad34c5ed8090d9d6.camel@sipsolutions.net>
         <CAKwvOdnQ9feXGYV2CUyVwg-FNAOmb4HBmDxMg243v28DzSfLuA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-03-29 at 10:30 -0700, Nick Desaulniers wrote:
> >=20
> > > Nick pointed out that the result of this division is being
> > > stored to a 32-bit type anyways, so truncate gp2_10ns first then do t=
he
> > > division, which elides the need for libcalls.
> >=20
> > That loses ~7 top bits though, no? I'd be more worried about that, than
> > the time div_u64() takes.
>=20
> The result is still stored in a u32; there is a loss of precision
> regardless of use of div_u64 or open coded binary operator /. =C2=A0
>=20

Right, obviously.

> So is
> the loss of precision before the division as tolerable as after the
> division?

For all I can tell this is meant to be 'gp2' with an additional lower
bits to reach a unit/granularity of 10ns, basically in FW something like

  gp2_10ns =3D gp2 * 100 + subsampling_10ns_unit

(and gp2 in FW is a 32-bit value, so it rolls over eventually).

But I _think_ we want to make a proper division by 100 to obtain back
the original 'gp2' value here.

johannes
