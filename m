Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBE850D921
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 08:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241319AbiDYGG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 02:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241345AbiDYGEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 02:04:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B457393D4;
        Sun, 24 Apr 2022 23:01:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DC96611CC;
        Mon, 25 Apr 2022 06:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0C6C385A7;
        Mon, 25 Apr 2022 06:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650866483;
        bh=jJSzwEMcRNQclSonKLXvhl6er2akDymhmWYinGpo/W8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=lSWzbJpMsUcGjsZldMreaAWEEO9jJDWy+f/3W96Q2SJDLVq06bKQd5Q1Yax9gvhU2
         V5tdlQC28gXmulRhky1zUjcXZoMNs+l0agLzfh9piHO6Tet4ytXfWqWTBdGU3MUcKm
         lRyrM4Sf72QILzk5qgzPNl4/HfTpanxn4x6Fqa01gtRZC1na+FqBqVYclazzIhckhQ
         ymMfezjxoVWv0f4iSVDXalh/LV0pfOnuE73KosBv95qY2aAxFjggYFsdVzKZFYfioL
         k6nf/wql32x6PRkGgcbg5ZZhL82T1OO08PU3L2OdCeqqdRKLGQbS3d/zUelZwjJXNh
         moqM24yUKrR0w==
From:   Kalle Valo <kvalo@kernel.org>
To:     z <zhaojunkui2008@126.com>
Cc:     "Jakub Kicinski" <kubakici@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "Matthias Brugger" <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        bernard@vivo.com
Subject: Re: [PATCH v2] mediatek/mt7601u: add debugfs exit function
In-Reply-To: <15b4f.2aad.1805ece06a1.Coremail.zhaojunkui2008@126.com> (z.'s
        message of "Mon, 25 Apr 2022 11:40:02 +0800 (CST)")
References: <20220422080854.490379-1-zhaojunkui2008@126.com>
        <20220422124704.259244e7@kicinski-fedora-PC1C0HJN>
        <15b4f.2aad.1805ece06a1.Coremail.zhaojunkui2008@126.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Mon, 25 Apr 2022 09:01:18 +0300
Message-ID: <87h76hk8gh.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

z  <zhaojunkui2008@126.com> writes:

> At 2022-04-23 03:47:04, "Jakub Kicinski" <kubakici@wp.pl> wrote:
>>On Fri, 22 Apr 2022 01:08:54 -0700 Bernard Zhao wrote:
>>> When mt7601u loaded, there are two cases:
>>> First when mt7601u is loaded, in function mt7601u_probe, if
>>> function mt7601u_probe run into error lable err_hw,
>>> mt7601u_cleanup didn`t cleanup the debugfs node.
>>> Second when the module disconnect, in function mt7601u_disconnect,
>>> mt7601u_cleanup didn`t cleanup the debugfs node.
>>> This patch add debugfs exit function and try to cleanup debugfs
>>> node when mt7601u loaded fail or unloaded.
>>>=20
>>> Signed-off-by: Bernard Zhao <zhaojunkui2008@126.com>
>>
>>Ah, missed that there was a v2. My point stands, wiphy debugfs dir
>>should do the cleanup.
>>
>>Do you encounter problems in practice or are you sending this patches
>>based on reading / static analysis of the code only.
>
> Hi Jakub Kicinski:
>
> The issue here is found by reading code.
> I read the drivers/net/wireless code and found that many modules are
> not cleanup the debugfs.
> I sorted out the modules that were not cleaned up the debugfs:
> ./ti/wl18xx
> ./ti/wl12xx
> ./intel/iwlwifi
> ./intel/iwlwifi
> ./mediatek/mt76
> I am not sure whether this part is welcome to kernel so I submitted a pat=
ch.
> If you have any suggestions, welcome to put forward for discussion, thank=
 you=EF=BC=81

Jakub is saying that wiphy_unregister() recursively removes the debugfs
directories:

	/*
	 * First remove the hardware from everywhere, this makes
	 * it impossible to find from userspace.
	 */
	debugfs_remove_recursive(rdev->wiphy.debugfsdir);

So AFAICS there is no bug. But if you are testing this on a real
hardware and something is wrong, please provide more info.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
