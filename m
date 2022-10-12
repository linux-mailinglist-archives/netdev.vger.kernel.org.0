Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC885FC08E
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 08:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiJLGVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 02:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJLGVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 02:21:34 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8F889976;
        Tue, 11 Oct 2022 23:21:33 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4MnMx31PJ1z4wgr;
        Wed, 12 Oct 2022 17:21:26 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1665555688;
        bh=YzBdtZALMPvevfqLcejSWQcfLQIXVl+Gp0Tn+SPwIqc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=hi74EGX3EywL/sADHCKfoPX61U5045pExe4Gpp8z3AbtcA/xv5uAJ6K95LyJ2pWlW
         jkcHE9uN3Nt0MjBgwmLihG8oM7P9FDR3geA8ZOadOMK0o5xep22cTFe8GP7XMQA/NL
         JyHAfz3zsqV5g4QmKSX0bx2Vm4GeuhuW7ONzdTmyVbXqjeW4Ur8YzNCn0sPagdL5eu
         5xnEM6372wNMxbuX0kvDTD5dJC0zkyRW1gMVbDOQTjaVEdd+VprV0C0DMBWXeQPgT0
         SlNvjimItgAL6+wEIx+/ViUGDEpj1ty2GS+dgdkjy3Qt5JJBH8WiTLUdIBbCn8MdX7
         cRZBm1/NS/Mvw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alvaro.karsz@solid-run.com, angus.chen@jaguarmicro.com,
        gavinl@nvidia.com, jasowang@redhat.com, lingshan.zhu@intel.com,
        mst@redhat.com, wangdeming@inspur.com, xiujianfeng@huawei.com,
        linuxppc-dev@lists.ozlabs.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] virtio: fixes, features
In-Reply-To: <20221010132030-mutt-send-email-mst@kernel.org>
References: <20221010132030-mutt-send-email-mst@kernel.org>
Date:   Wed, 12 Oct 2022 17:21:24 +1100
Message-ID: <87r0zdmujf.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> The following changes since commit 4fe89d07dcc2804c8b562f6c7896a45643d34b2f:
>
>   Linux 6.0 (2022-10-02 14:09:07 -0700)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus
>
> for you to fetch changes up to 71491c54eafa318fdd24a1f26a1c82b28e1ac21d:
>
>   virtio_pci: don't try to use intxif pin is zero (2022-10-07 20:00:44 -0400)
>
> ----------------------------------------------------------------
> virtio: fixes, features
>
> 9k mtu perf improvements
> vdpa feature provisioning
> virtio blk SECURE ERASE support
>
> Fixes, cleanups all over the place.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>
> ----------------------------------------------------------------
> Alvaro Karsz (1):
>       virtio_blk: add SECURE ERASE command support
>
> Angus Chen (1):
>       virtio_pci: don't try to use intxif pin is zero

This commit breaks virtio_pci for me on powerpc, when running as a qemu
guest.

vp_find_vqs() bails out because pci_dev->pin == 0.

But pci_dev->irq is populated correctly, so vp_find_vqs_intx() would
succeed if we called it - which is what the code used to do.

I think this happens because pci_dev->pin is not populated in
pci_assign_irq().

I would absolutely believe this is bug in our PCI code, but I think it
may also affect other platforms that use of_irq_parse_and_map_pci().

cheers
