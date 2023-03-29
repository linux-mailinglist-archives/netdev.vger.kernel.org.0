Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719D96CF0E7
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 19:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjC2RU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 13:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjC2RUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 13:20:55 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A562410CB;
        Wed, 29 Mar 2023 10:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=ndV/uVcgkkvqmSP7Qrduc49yJn9Zllur/T1MQQBPJbk=;
        t=1680110453; x=1681320053; b=aB7RoUed7zlvscD7UkUpbvYeSsxOyP4HxvNnMmVJ1rS+IQ+
        UR0QOSOauH+NzI6h8e0RjguMnlV1d2O5pvbE51gGIaqfmuOBwT5qkKhMFvoBijFgp1ZKhbDi3axm4
        Hct+1lasgGhZA5oAMxi0FKF64YcmkjedPhR0Ll2B4QJShGQhBvSUc7Iq8i0KcX4HItwYlRNxN/Szb
        ZQfXrcnrVNmnl4MRMDXCTJN1iSNisj3LoCr9AWkK0F502Ft7MBe1Jdj8hG6lgt4SuO71vMoUTHHmv
        9CF8UP1T8scQSvmq7N3C1GuT4fMx0QyEIWDqaqSaGStl4b+P/8WOCAspTTl42T+Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1phZTY-000AWN-1j;
        Wed, 29 Mar 2023 19:20:44 +0200
Message-ID: <9058a032c177e9b04adbf944ad34c5ed8090d9d6.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next] wifi: iwlwifi: mvm: Avoid 64-bit division
 in iwl_mvm_get_crosstimestamp_fw()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Nathan Chancellor <nathan@kernel.org>, gregory.greenman@intel.com,
        kvalo@kernel.org
Cc:     ndesaulniers@google.com, trix@redhat.com, avraham.stern@intel.com,
        krishnanand.prabhu@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev,
        Arnd Bergmann <arnd@arndb.de>,
        "kernelci.org bot" <bot@kernelci.org>
Date:   Wed, 29 Mar 2023 19:20:43 +0200
In-Reply-To: <20230329-iwlwifi-ptp-avoid-64-bit-div-v1-1-ad8db8d66bc2@kernel.org>
References: <20230329-iwlwifi-ptp-avoid-64-bit-div-v1-1-ad8db8d66bc2@kernel.org>
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

On Wed, 2023-03-29 at 10:05 -0700, Nathan Chancellor wrote:
>=20
> GCC has optimizations for division by a constant that clang does not
> implement, so this issue is not visible when building with GCC.

Huh yeah, we did 32-bit builds with gcc ...

> Using div_u64() would resolve this issue, but Arnd points out that this
> can be quite expensive and the timestamp is being read at nanosecond
> granularity.=C2=A0

Doesn't matter though, all the calculations are based on just the
command response from the firmware, which (tries to) take it in a
synchronised fashion.

So taking more time here would be fine, as far as I can tell.

> Nick pointed out that the result of this division is being
> stored to a 32-bit type anyways, so truncate gp2_10ns first then do the
> division, which elides the need for libcalls.

That loses ~7 top bits though, no? I'd be more worried about that, than
the time div_u64() takes.

johannes
