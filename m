Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE432D8779
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 17:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439293AbgLLQAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 11:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726056AbgLLQAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 11:00:15 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148A0C0613CF
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 07:59:35 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id b73so12577704edf.13
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 07:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zIwI0sptbQ/UXBRsNdcBoBGQ2696xAVOu1c/oNd92yo=;
        b=AWFaWlvF9qNA7fj7Ex9EVxMZpR71Y6npIkv3NacaloTKsKGnGo361wxvXoQXTzDkr9
         3LiEpaGDe2whfkNFVv0lodk6j9bdyznX7+eLyvy63/Rn0u7Ti0DeyMqrLffXZ3V6TjLt
         fx+UuKm+uQcR9VHkq32f8OmmV3cqQZU1l2CPabOdGtKV5Vx6DcOowlA7EjdLuuOqwo6t
         WBWE38ADMk1WuQjbUdBwJKYYwhu6o1mFSOB2q6mNJ492ScSyR+OFm1+PiQ/4dZ5PklTC
         tnSO5WT3Z0LrRRf1YLijK04AdmF23Xs8asPHxT5xD0madGO/aq4mZhXhqVtqc6pgRdhY
         PSmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zIwI0sptbQ/UXBRsNdcBoBGQ2696xAVOu1c/oNd92yo=;
        b=mQcABVT60Op1QjWgD7Lhw+XZ4NIIK5nCq+3K170wztijkCbbuPyUXa6wC4oDaq4TbT
         uZnJZS9vHZnDRSIrsi8BhZCuH/tuLGd2sGoR/pNa6uYpajGM5I3mnMu9tBoM5di5z25I
         CQhPCjMT6ENWfUlJCx2uG4orUCpXCUhJKkXYpb4fTtxrscDOYaAAQe9WOMWrK0b1vBQz
         kz+AtnVei44SL+NybZC7b0XhnR7O59wZs22CIS4ziYHtDSsXIgKpRJ094IRHAnVNkiCy
         goYFZnq2wfGs8hK2bfb+zdMuhKrCvZqlcbweukWYHQn/KyC8nhDxy8ZR52vyxiGCZF+b
         8RJg==
X-Gm-Message-State: AOAM533BA16emt1iGVHdptMldj9I1PQD7ExJP4/du+m/MFfQEI2XtHGU
        rktct3fQU5Kvu3Y12vmqsZYbvFbCyWtENf2N8zN+hUUxo5U=
X-Google-Smtp-Source: ABdhPJyWuXiBNapcIGS8gA/hYxUVwClwdMaoT55oXf6GNdHooVhUL4nPfVqdoP9zDjgiqNljzyJufW9Tl1n46PLlwlI=
X-Received: by 2002:a50:f307:: with SMTP id p7mr17166792edm.368.1607788773768;
 Sat, 12 Dec 2020 07:59:33 -0800 (PST)
MIME-Version: 1.0
References: <20201210173156.mbizovo6rxvkda73@holly.lan> <20201210180636.nsfwvzs5xxzpqt7n@skbuf>
 <20201211140126.25x4z2x6upctyin5@skbuf> <20201211162914.pa3eua4nerviysyy@holly.lan>
 <20201211165434.6qdk6hswmryhn7z6@skbuf>
In-Reply-To: <20201211165434.6qdk6hswmryhn7z6@skbuf>
From:   Jon Nettleton <jon@solid-run.com>
Date:   Sat, 12 Dec 2020 16:58:56 +0100
Message-ID: <CABdtJHvyWSaJw1F0c9J8XbdJsxrkP9d++D0btseaO0eRRNJcyg@mail.gmail.com>
Subject: Re: [PATCH RESEND net-next 1/2] dpaa2-eth: send a scatter-gather FD
 instead of realloc-ing
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Daniel Thompson <daniel.thompson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 5:56 PM Ioana Ciornei <ioana.ciornei@nxp.com> wrote:
>
> On Fri, Dec 11, 2020 at 04:29:14PM +0000, Daniel Thompson wrote:
> > On Fri, Dec 11, 2020 at 02:01:28PM +0000, Ioana Ciornei wrote:
> > > On Thu, Dec 10, 2020 at 08:06:36PM +0200, Ioana Ciornei wrote:
> > > > [Added also the netdev mailing list, I haven't heard of linux-netdev
> > > > before but kept it]
> > > >
> > > > On Thu, Dec 10, 2020 at 05:31:56PM +0000, Daniel Thompson wrote:
> > > > > Hi Ioana
> > > >
> > > > Hi Daniel,
> > > >
> > > > >
> > > > > On Mon, Jun 29, 2020 at 06:47:11PM +0000, Ioana Ciornei wrote:
> > > > > > Instead of realloc-ing the skb on the Tx path when the provided headroom
> > > > > > is smaller than the HW requirements, create a Scatter/Gather frame
> > > > > > descriptor with only one entry.
> > > > > >
> > > > > > Remove the '[drv] tx realloc frames' counter exposed previously through
> > > > > > ethtool since it is no longer used.
> > > > > >
> > > > > > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > > > > ---
> > > > >
> > > > > I've been chasing down a networking regression on my LX2160A board
> > > > > (Honeycomb LX2K based on CEx7 LX2160A COM) that first appeared in v5.9.
> > > > >
> > > > > It makes the board unreliable opening outbound connections meaning
> > > > > things like `apt update` or `git fetch` often can't open the connection.
> > > > > It does not happen all the time but is sufficient to make the boards
> > > > > built-in networking useless for workstation use.
> > > > >
> > > > > The problem is strongly linked to warnings in the logs so I used the
> > > > > warnings to bisect down to locate the cause of the regression and it
> > > > > pinpointed this patch. I have confirmed that in both v5.9 and v5.10-rc7
> > > > > that reverting this patch (and fixing up the merge issues) fixes the
> > > > > regression and the warnings stop appearing.
> > > > >
> > > > > A typical example of the warning is below (io-pgtable-arm.c:281 is an
> > > > > error path that I guess would cause dma_map_page_attrs() to return
> > > > > an error):
> > > > >
> > > > > [  714.464927] WARNING: CPU: 13 PID: 0 at
> > > > > drivers/iommu/io-pgtable-arm.c:281 __arm_lpae_map+0x2d4/0x30c
> > > > > [  714.464930] Modules linked in: snd_seq_dummy(E) snd_hrtimer(E)
> > > > > snd_seq(E) snd_seq_device(E) snd_timer(E) snd(E) soundcore(E) bridge(E)
> > > > > stp(E) llc(E) rfkill(E) caam_jr(E) crypto_engine(E) rng_core(E)
> > > > > joydev(E) evdev(E) dpaa2_caam(E) caamhash_desc(E) caamalg_desc(E)
> > > > > authenc(E) libdes(E) dpaa2_console(E) ofpart(E) caam(E) sg(E) error(E)
> > > > > lm90(E) at24(E) spi_nor(E) mtd(E) sbsa_gwdt(E) qoriq_thermal(E)
> > > > > layerscape_edac_mod(E) qoriq_cpufreq(E) drm(E) fuse(E) configfs(E)
> > > > > ip_tables(E) x_tables(E) autofs4(E) ext4(E) crc32c_generic(E) crc16(E)
> > > > > mbcache(E) jbd2(E) hid_generic(E) usbhid(E) hid(E) dm_crypt(E) dm_mod(E)
> > > > > sd_mod(E) fsl_dpaa2_ptp(E) ptp_qoriq(E) fsl_dpaa2_eth(E)
> > > > > xhci_plat_hcd(E) xhci_hcd(E) usbcore(E) aes_ce_blk(E) crypto_simd(E)
> > > > > cryptd(E) aes_ce_cipher(E) ghash_ce(E) gf128mul(E) at803x(E) libaes(E)
> > > > > fsl_mc_dpio(E) pcs_lynx(E) rtc_pcf2127(E) sha2_ce(E) phylink(E)
> > > > > xgmac_mdio(E) regmap_spi(E) of_mdio(E) sha256_arm64(E)
> > > > > i2c_mux_pca954x(E) fixed_phy(E) i2c_mux(E) sha1_ce(E) ptp(E) libphy(E)
> > > > > [  714.465131]  pps_core(E) ahci_qoriq(E) libahci_platform(E) nvme(E)
> > > > > libahci(E) nvme_core(E) t10_pi(E) libata(E) crc_t10dif(E)
> > > > > crct10dif_generic(E) crct10dif_common(E) dwc3(E) scsi_mod(E) udc_core(E)
> > > > > roles(E) ulpi(E) sdhci_of_esdhc(E) sdhci_pltfm(E) sdhci(E)
> > > > > spi_nxp_fspi(E) i2c_imx(E) fixed(E)
> > > > > [  714.465192] CPU: 13 PID: 0 Comm: swapper/13 Tainted: G        W   E
> > > > > 5.10.0-rc7-00001-gba98d13279ca #52
> > > > > [  714.465196] Hardware name: SolidRun LX2160A Honeycomb (DT)
> > > > > [  714.465202] pstate: 60000005 (nZCv daif -PAN -UAO -TCO BTYPE=--)
> > > > > [  714.465207] pc : __arm_lpae_map+0x2d4/0x30c
> > > > > [  714.465211] lr : __arm_lpae_map+0x114/0x30c
> > > > > [  714.465215] sp : ffff80001006b340
> > > > > [  714.465219] x29: ffff80001006b340 x28: 0000002086538003
> > > > > [  714.465227] x27: 0000000000000a20 x26: 0000000000001000
> > > > > [  714.465236] x25: 0000000000000f44 x24: 00000020adf8d000
> > > > > [  714.465245] x23: 0000000000000001 x22: 0000fffffaeca000
> > > > > [  714.465253] x21: 0000000000000003 x20: ffff19b60d64d200
> > > > > [  714.465261] x19: 00000000000000ca x18: 0000000000000000
> > > > > [  714.465270] x17: 0000000000000000 x16: ffffcccb7cf3ca20
> > > > > [  714.465278] x15: 0000000000000000 x14: 0000000000000000
> > > > > [  714.465286] x13: 0000000000000003 x12: 0000000000000010
> > > > > [  714.465294] x11: 0000000000000000 x10: 0000000000000002
> > > > > [  714.465302] x9 : ffffcccb7d5b6e78 x8 : 00000000000001ff
> > > > > [  714.465311] x7 : ffff19b606538650 x6 : ffff19b606538000
> > > > > [  714.465319] x5 : 0000000000000009 x4 : 0000000000000f44
> > > > > [  714.465327] x3 : 0000000000001000 x2 : 00000020adf8d000
> > > > > [  714.465335] x1 : 0000000000000002 x0 : 0000000000000003
> > > > > [  714.465343] Call trace:
> > > > > [  714.465348]  __arm_lpae_map+0x2d4/0x30c
> > > > > [  714.465353]  __arm_lpae_map+0x114/0x30c
> > > > > [  714.465357]  __arm_lpae_map+0x114/0x30c
> > > > > [  714.465362]  __arm_lpae_map+0x114/0x30c
> > > > > [  714.465366]  arm_lpae_map+0xf4/0x180
> > > > > [  714.465373]  arm_smmu_map+0x4c/0xc0
> > > > > [  714.465379]  __iommu_map+0x100/0x2bc
> > > > > [  714.465385]  iommu_map_atomic+0x20/0x30
> > > > > [  714.465391]  __iommu_dma_map+0xb0/0x110
> > > > > [  714.465397]  iommu_dma_map_page+0xb8/0x120
> > > > > [  714.465404]  dma_map_page_attrs+0x1a8/0x210
> > > > > [  714.465413]  __dpaa2_eth_tx+0x384/0xbd0 [fsl_dpaa2_eth]
> > > > > [  714.465421]  dpaa2_eth_tx+0x84/0x134 [fsl_dpaa2_eth]
> > > > > [  714.465427]  dev_hard_start_xmit+0x10c/0x2b0
> > > > > [  714.465433]  sch_direct_xmit+0x1a0/0x550
> > > > > [  714.465438]  __qdisc_run+0x140/0x670
> > > > > [  714.465443]  __dev_queue_xmit+0x6c4/0xa74
> > > > > [  714.465449]  dev_queue_xmit+0x20/0x2c
> > > > > [  714.465463]  br_dev_queue_push_xmit+0xc4/0x1a0 [bridge]
> > > > > [  714.465476]  br_forward_finish+0xdc/0xf0 [bridge]
> > > > > [  714.465489]  __br_forward+0x160/0x1c0 [bridge]
> > > > > [  714.465502]  br_forward+0x13c/0x160 [bridge]
> > > > > [  714.465514]  br_dev_xmit+0x228/0x3b0 [bridge]
> > > > > [  714.465520]  dev_hard_start_xmit+0x10c/0x2b0
> > > > > [  714.465526]  __dev_queue_xmit+0x8f0/0xa74
> > > > > [  714.465531]  dev_queue_xmit+0x20/0x2c
> > > > > [  714.465538]  arp_xmit+0xc0/0xd0
> > > > > [  714.465544]  arp_send_dst+0x78/0xa0
> > > > > [  714.465550]  arp_solicit+0xf4/0x260
> > > > > [  714.465554]  neigh_probe+0x64/0xb0
> > > > > [  714.465560]  neigh_timer_handler+0x2f4/0x400
> > > > > [  714.465566]  call_timer_fn+0x3c/0x184
> > > > > [  714.465572]  __run_timers.part.0+0x2bc/0x370
> > > > > [  714.465578]  run_timer_softirq+0x48/0x80
> > > > > [  714.465583]  __do_softirq+0x120/0x36c
> > > > > [  714.465589]  irq_exit+0xac/0x100
> > > > > [  714.465596]  __handle_domain_irq+0x8c/0xf0
> > > > > [  714.465600]  gic_handle_irq+0xcc/0x14c
> > > > > [  714.465605]  el1_irq+0xc4/0x180
> > > > > [  714.465610]  arch_cpu_idle+0x18/0x30
> > > > > [  714.465617]  default_idle_call+0x4c/0x180
> > > > > [  714.465623]  do_idle+0x238/0x2b0
> > > > > [  714.465629]  cpu_startup_entry+0x30/0xa0
> > > > > [  714.465636]  secondary_start_kernel+0x134/0x180
> > > > > [  714.465640] ---[ end trace a84a7f61b559005f ]---
> > > > >
> > > > >
> > > > > Given it is the iommu code that is provoking the warning I should
> > > > > probably mention that the board I have requires
> > > > > arm-smmu.disable_bypass=0 on the kernel command line in order to boot.
> > > > > Also if it matters I am running the latest firmware from Solidrun
> > > > > which is based on LSDK-20.04.
> > > > >
> > > >
> > > > Hmmm, from what I remember I think I tested this with the smmu bypassed
> > > > so that is why I didn't catch it.
> > > >
> > > > > Is there any reason for this code not to be working for LX2160A?
> > > >
> > > > I wouldn't expect this to be LX2160A specific but rather a bug in the
> > > > implementation.. sorry.
> > > >
> > > > Let me reproduce it and see if I can get to the bottom of it and I will
> > > > get back with some more info.
> > > >
> > >
> > > Hi Daniel,
> > >
> > > It seems that the dma-unmapping on the SGT buffer was incorrectly done
> > > with a zero size since on the Tx path I initialized the improper field.
> > >
> > > Could you test the following diff and let me know if you can generate
> > > the WARNINGs anymore?
> >
> > I fired this up and, with your change, I've not been able to trigger
> > the warning with the tests that I used the drive my bisect.
> >
>
> Great, thanks for testing this.
>
> I will take care of sending the fix to -net.
>
> Ioana

Ioana,

Please CC me when you send the patch to -net, I will put my Tested-by: on it.

Thanks
Jon

>
> > Thanks for the quick response.
> >
> >
> > Daniel.
> >
> >
> > >
> > > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > > @@ -878,7 +878,7 @@ static int dpaa2_eth_build_sg_fd_single_buf(struct dpaa2_eth_priv *priv,
> > >         swa = (struct dpaa2_eth_swa *)sgt_buf;
> > >         swa->type = DPAA2_ETH_SWA_SINGLE;
> > >         swa->single.skb = skb;
> > > -       swa->sg.sgt_size = sgt_buf_size;
> > > +       swa->single.sgt_size = sgt_buf_size;
> > >
> > >         /* Separately map the SGT buffer */
> > >         sgt_addr = dma_map_single(dev, sgt_buf, sgt_buf_size, DMA_BIDIRECTIONAL);
> > >
> > >
> > > Ioana
