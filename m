Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A761202CD4
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 22:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730727AbgFUUyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 16:54:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730663AbgFUUyT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 16:54:19 -0400
Received: from localhost (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6EA92528A;
        Sun, 21 Jun 2020 20:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592772859;
        bh=2eTd2YSiQ4jc/vVZeSfHDWa/Dk3CU1e4D9cG1p+gGc4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mV047qAm3pRt84Tvpu86rPB6W+QNHCsMDXTIECwyc4W0KJk1LrPqKJCd4m87VGWny
         1w2K+PTxTN+rBTVfHHBEJ3rj9hVjBAET08sAIv+VBQLWv835riKxqBjGdpr0Tmj6hX
         qBX9VugU95JyflsWT3+mv9HTWo+P57PeXovmgyaA=
Date:   Sun, 21 Jun 2020 22:54:12 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Oleksandr Natalenko <oleksandr@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: mt7612 suspend/resume issue
Message-ID: <20200621205412.GB271428@localhost.localdomain>
References: <20200618090556.pepjdbnba2gqzcbe@butterfly.localdomain>
 <20200618111859.GC698688@lore-desk.lan>
 <20200619150132.2zrc3ojqhtbn432u@butterfly.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
Content-Disposition: inline
In-Reply-To: <20200619150132.2zrc3ojqhtbn432u@butterfly.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hello, Lorenzo.

Hi Oleksandr,

>=20
> Thanks for the quick reply. Please see my observation below.
>=20
> On Thu, Jun 18, 2020 at 01:18:59PM +0200, Lorenzo Bianconi wrote:
> > I have not reproduced the issue myself yet, but I guess we can try:
> > 1- update to latest Felix's tree [1]
> > 2- could you please try to apply the patch below? (compile-test only)
>=20
> I've started with trying your patch first (apllied to v5.7.4). Please
> see my comments on it inline.
>=20
> > [1] https://github.com/nbd168/wireless
> >=20
> > From 400268a0ee5843cf736308504dfbd2f20a291eaf Mon Sep 17 00:00:00 2001
> > Message-Id: <400268a0ee5843cf736308504dfbd2f20a291eaf.1592478809.git.lo=
renzo@kernel.org>
> > From: Lorenzo Bianconi <lorenzo@kernel.org>
> > Date: Thu, 18 Jun 2020 13:10:11 +0200
> > Subject: [PATCH] mt76: mt76x2: fix pci suspend
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---

[...]

> > +	for (i =3D 0; i < __MT_TXQ_MAX; i++)
> > +		mt76_queue_tx_cleanup(dev, i, true);
> > +	mt76_for_each_q_rx(&dev->mt76, i)
>=20
> Since v5.7.4 doesn't have this macro, I've pulled it manually.

this is why I asked to use Felix's tree :)

>=20
> > +		mt76_queue_rx_reset(dev, i);
> > +
> > +	mt76x02_dma_enable(dev);
> > +}
>=20
> I had to add EXPORT_SYMBOL_GPL(mt76x02_dma_reset) in order to get the
> kernel linked successfully.

ack, sorry

>=20
> > +
> >  void mt76x02_mac_start(struct mt76x02_dev *dev)
> >  {
> >  	mt76x02_mac_reset_counters(dev);
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c b/drivers/=
net/wireless/mediatek/mt76/mt76x2/pci.c
> > index 53ca0cedf026..5543e242fb9b 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
> > @@ -103,6 +103,60 @@ mt76pci_remove(struct pci_dev *pdev)
> >  	mt76_free_device(mdev);
> >  }
> > =20
> > +static int __maybe_unused
> > +mt76x2e_suspend(struct pci_dev *pdev, pm_message_t state)
> > +{
> > +	struct mt76_dev *mdev =3D pci_get_drvdata(pdev);
> > +	struct mt76x02_dev *dev =3D container_of(mdev, struct mt76x02_dev, mt=
76);
> > +	int i, err;

can you please double-check what is the PCI state requested during suspend?

Regards,
Lorenzo

> > +
> > +	napi_disable(&mdev->tx_napi);
> > +	tasklet_kill(&mdev->pre_tbtt_tasklet);
> > +	tasklet_kill(&mdev->tx_tasklet);
> > +
> > +	mt76_for_each_q_rx(mdev, i)
> > +		napi_disable(&mdev->napi[i]);
> > +
> > +	mt76x02_dma_reset(dev);
> > +
> > +	pci_enable_wake(pdev, pci_choose_state(pdev, state), true);
> > +	pci_save_state(pdev);
> > +	err =3D pci_set_power_state(pdev, pci_choose_state(pdev, state));
> > +	if (err)
> > +		goto restore;
> > +
> > +	return 0;
> > +
> > +restore:
> > +	mt76_for_each_q_rx(mdev, i)
> > +		napi_enable(&mdev->napi[i]);
> > +	napi_enable(&mdev->tx_napi);
> > +
> > +	return err;
> > +}
> > +
> > +static int __maybe_unused
> > +mt76x2e_resume(struct pci_dev *pdev)
> > +{
> > +	struct mt76_dev *mdev =3D pci_get_drvdata(pdev);
> > +	int i, err;
> > +
> > +	err =3D pci_set_power_state(pdev, PCI_D0);
> > +	if (err)
> > +		return err;
> > +
> > +	pci_restore_state(pdev);
> > +
> > +	mt76_for_each_q_rx(mdev, i) {
> > +		napi_enable(&mdev->napi[i]);
> > +		napi_schedule(&mdev->napi[i]);
> > +	}
> > +	napi_enable(&mdev->tx_napi);
> > +	napi_schedule(&mdev->tx_napi);
> > +
> > +	return 0;
> > +}
> > +
> >  MODULE_DEVICE_TABLE(pci, mt76pci_device_table);
> >  MODULE_FIRMWARE(MT7662_FIRMWARE);
> >  MODULE_FIRMWARE(MT7662_ROM_PATCH);
> > @@ -113,6 +167,10 @@ static struct pci_driver mt76pci_driver =3D {
> >  	.id_table	=3D mt76pci_device_table,
> >  	.probe		=3D mt76pci_probe,
> >  	.remove		=3D mt76pci_remove,
> > +#ifdef CONFIG_PM
> > +	.suspend	=3D mt76x2e_suspend,
> > +	.resume		=3D mt76x2e_resume,
> > +#endif /* CONFIG_PM */
> >  };
> > =20
> >  module_pci_driver(mt76pci_driver);
> > --=20
> > 2.26.2
>=20
> Unfortunately, it seems it did little change to my setup. The resume
> time shrunk it seems (but is still noticeable), and the system survived
> 2 suspend/resume cycles, but after the third resume the following
> happened:
>=20
> =3D=3D=3D
> =C4=8Den 18 23:11:58 spock kernel: mt76x2e 0000:01:00.0: MCU message 2 (s=
eq 11) timed out
> =C4=8Den 18 23:11:58 spock kernel: mt76x2e 0000:01:00.0: MCU message 30 (=
seq 12) timed out
> =C4=8Den 18 23:11:58 spock kernel: mt76x2e 0000:01:00.0: MCU message 30 (=
seq 13) timed out
> =C4=8Den 18 23:11:58 spock kernel: mt76x2e 0000:01:00.0: Firmware Version=
: 0.0.00
> =C4=8Den 18 23:11:58 spock kernel: mt76x2e 0000:01:00.0: Build: 1
> =C4=8Den 18 23:11:58 spock kernel: mt76x2e 0000:01:00.0: Build Time: 2015=
07311614____
> =C4=8Den 18 23:11:58 spock kernel: mt76x2e 0000:01:00.0: Firmware running!
> =C4=8Den 18 23:11:58 spock kernel: ieee80211 phy0: Hardware restart was r=
equested
> =C4=8Den 18 23:11:59 spock kernel: mt76x2e 0000:01:00.0: MCU message 2 (s=
eq 1) timed out
> =C4=8Den 18 23:11:59 spock kernel: mt76x2e 0000:01:00.0: Firmware Version=
: 0.0.00
> =C4=8Den 18 23:11:59 spock kernel: mt76x2e 0000:01:00.0: Build: 1
> =C4=8Den 18 23:11:59 spock kernel: mt76x2e 0000:01:00.0: Build Time: 2015=
07311614____
> =C4=8Den 18 23:11:59 spock kernel: mt76x2e 0000:01:00.0: Firmware running!
> =C4=8Den 18 23:11:59 spock kernel: ieee80211 phy0: Hardware restart was r=
equested
> =C4=8Den 18 23:12:00 spock kernel: mt76x2e 0000:01:00.0: MCU message 30 (=
seq 3) timed out
> =C4=8Den 18 23:12:01 spock kernel: mt76x2e 0000:01:00.0: MCU message 30 (=
seq 4) timed out
> =C4=8Den 18 23:12:01 spock kernel: mt76x2e 0000:01:00.0: Firmware Version=
: 0.0.00
> =C4=8Den 18 23:12:01 spock kernel: mt76x2e 0000:01:00.0: Build: 1
> =C4=8Den 18 23:12:01 spock kernel: mt76x2e 0000:01:00.0: Build Time: 2015=
07311614____
> =C4=8Den 18 23:12:01 spock kernel: mt76x2e 0000:01:00.0: Firmware running!
> =C4=8Den 18 23:12:01 spock kernel: ieee80211 phy0: Hardware restart was r=
equested
> =C4=8Den 18 23:12:02 spock kernel: ------------[ cut here ]------------
> =C4=8Den 18 23:12:02 spock kernel: WARNING: CPU: 3 PID: 171 at net/mac802=
11/util.c:2270 ieee80211_reconfig+0x234/0x1700 [mac80211]
> =C4=8Den 18 23:12:02 spock kernel: Modules linked in: cmac ccm bridge stp=
 llc nft_ct nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables msr tun nf=
netlink nls_iso8859_1 nls_cp437 vfat fat mt76x2e mt76x2_common mt76x02_lib =
mt76 mac80211 intel_rapl_msr snd_hda_codec_hdmi snd_hda_codec_cirrus mei_hd=
cp snd_hda_codec_generic cfg80211 intel_rapl_common x86_pkg_temp_thermal in=
tel_powerclamp coretemp dell_laptop iTCO_wdt snd_hda_intel kvm_intel iTCO_v=
endor_support dell_wmi snd_intel_dspcfg sparse_keymap snd_hda_codec ledtrig=
_audio wmi_bmof dell_smbios snd_hda_core kvm rtsx_usb_ms dell_wmi_descripto=
r memstick dcdbas snd_hwdep dell_smm_hwmon irqbypass psmouse intel_cstate s=
nd_pcm intel_uncore joydev intel_rapl_perf mousedev mei_me alx rfkill input=
_leds snd_timer i2c_i801 snd mei lpc_ich libarc4 mdio soundcore battery wmi=
 evdev dell_smo8800 mac_hid ac tcp_bbr crypto_user ip_tables x_tables xfs d=
m_thin_pool dm_persistent_data dm_bio_prison dm_bufio libcrc32c crc32c_gene=
ric dm_crypt hid_logitech_hidpp hid_logitech_dj
> =C4=8Den 18 23:12:02 spock kernel:  hid_generic usbhid hid rtsx_usb_sdmmc=
 mmc_core rtsx_usb dm_mod raid10 serio_raw atkbd libps2 md_mod crct10dif_pc=
lmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel crypto_simd =
cryptd glue_helper xhci_pci xhci_hcd ehci_pci ehci_hcd i8042 serio i915 int=
el_gtt i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys=
_fops cec rc_core drm agpgart
> =C4=8Den 18 23:12:02 spock kernel: CPU: 3 PID: 171 Comm: kworker/3:3 Not =
tainted 5.7.0-pf3 #1
> =C4=8Den 18 23:12:02 spock kernel: Hardware name: Dell Inc.          Vost=
ro 3360/0F5DWF, BIOS A18 09/25/2013
> =C4=8Den 18 23:12:02 spock kernel: Workqueue: events_freezable ieee80211_=
restart_work [mac80211]
> =C4=8Den 18 23:12:02 spock kernel: RIP: 0010:ieee80211_reconfig+0x234/0x1=
700 [mac80211]
> =C4=8Den 18 23:12:02 spock kernel: Code: 83 b8 0b 00 00 83 e0 fd 83 f8 04=
 74 e6 48 8b 83 90 04 00 00 a8 01 74 db 48 89 de 48 89 ef e8 03 dc fb ff 41=
 89 c7 85 c0 74 c9 <0f> 0b 48 8b 5b 08 4c 8b 24 24 48 3b 1c 24 75 12 e9 51 =
fe ff ff 48
> =C4=8Den 18 23:12:02 spock kernel: RSP: 0018:ffffa87c40403df0 EFLAGS: 000=
10286
> =C4=8Den 18 23:12:02 spock kernel: RAX: 00000000fffffff0 RBX: ffff9fe028f=
6e900 RCX: 0000000000000008
> =C4=8Den 18 23:12:02 spock kernel: RDX: 0000000000000000 RSI: 00000000000=
00100 RDI: 0000000000000100
> =C4=8Den 18 23:12:02 spock kernel: RBP: ffff9fe0283787e0 R08: 00000000000=
00000 R09: 0000000000000001
> =C4=8Den 18 23:12:02 spock kernel: R10: 0000000000000001 R11: 00000000000=
00000 R12: ffff9fe0283798d0
> =C4=8Den 18 23:12:02 spock kernel: R13: 00000000ffffffff R14: 00000000000=
00000 R15: 00000000fffffff0
> =C4=8Den 18 23:12:02 spock kernel: FS:  0000000000000000(0000) GS:ffff9fe=
02f2c0000(0000) knlGS:0000000000000000
> =C4=8Den 18 23:12:02 spock kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000=
00080050033
> =C4=8Den 18 23:12:02 spock kernel: CR2: 00007f313b33a940 CR3: 000000012ea=
0a002 CR4: 00000000001706e0
> =C4=8Den 18 23:12:02 spock kernel: Call Trace:
> =C4=8Den 18 23:12:02 spock kernel:  ieee80211_restart_work+0xb7/0xe0 [mac=
80211]
> =C4=8Den 18 23:12:02 spock kernel:  process_one_work+0x1d4/0x3c0
> =C4=8Den 18 23:12:02 spock kernel:  worker_thread+0x228/0x470
> =C4=8Den 18 23:12:02 spock kernel:  ? process_one_work+0x3c0/0x3c0
> =C4=8Den 18 23:12:02 spock kernel:  kthread+0x19c/0x1c0
> =C4=8Den 18 23:12:02 spock kernel:  ? __kthread_init_worker+0x30/0x30
> =C4=8Den 18 23:12:02 spock kernel:  ret_from_fork+0x35/0x40
> =C4=8Den 18 23:12:02 spock kernel: ---[ end trace e017bc3573bd9bf2 ]---
> =C4=8Den 18 23:12:02 spock kernel: ------------[ cut here ]------------
> =C4=8Den 18 23:12:02 spock kernel: wlp1s0:  Failed check-sdata-in-driver =
check, flags: 0x0
> =C4=8Den 18 23:12:02 spock kernel: WARNING: CPU: 3 PID: 171 at net/mac802=
11/driver-ops.h:17 drv_remove_interface+0x11f/0x130 [mac80211]
> =C4=8Den 18 23:12:02 spock kernel: Modules linked in: cmac ccm bridge stp=
 llc nft_ct nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables msr tun nf=
netlink nls_iso8859_1 nls_cp437 vfat fat mt76x2e mt76x2_common mt76x02_lib =
mt76 mac80211 intel_rapl_msr snd_hda_codec_hdmi snd_hda_codec_cirrus mei_hd=
cp snd_hda_codec_generic cfg80211 intel_rapl_common x86_pkg_temp_thermal in=
tel_powerclamp coretemp dell_laptop iTCO_wdt snd_hda_intel kvm_intel iTCO_v=
endor_support dell_wmi snd_intel_dspcfg sparse_keymap snd_hda_codec ledtrig=
_audio wmi_bmof dell_smbios snd_hda_core kvm rtsx_usb_ms dell_wmi_descripto=
r memstick dcdbas snd_hwdep dell_smm_hwmon irqbypass psmouse intel_cstate s=
nd_pcm intel_uncore joydev intel_rapl_perf mousedev mei_me alx rfkill input=
_leds snd_timer i2c_i801 snd mei lpc_ich libarc4 mdio soundcore battery wmi=
 evdev dell_smo8800 mac_hid ac tcp_bbr crypto_user ip_tables x_tables xfs d=
m_thin_pool dm_persistent_data dm_bio_prison dm_bufio libcrc32c crc32c_gene=
ric dm_crypt hid_logitech_hidpp hid_logitech_dj
> =C4=8Den 18 23:12:02 spock kernel:  hid_generic usbhid hid rtsx_usb_sdmmc=
 mmc_core rtsx_usb dm_mod raid10 serio_raw atkbd libps2 md_mod crct10dif_pc=
lmul crc32_pclmul crc32c_intel ghash_clmulni_intel aesni_intel crypto_simd =
cryptd glue_helper xhci_pci xhci_hcd ehci_pci ehci_hcd i8042 serio i915 int=
el_gtt i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys=
_fops cec rc_core drm agpgart
> =C4=8Den 18 23:12:02 spock kernel: CPU: 3 PID: 171 Comm: kworker/3:3 Tain=
ted: G        W         5.7.0-pf3 #1
> =C4=8Den 18 23:12:02 spock kernel: Hardware name: Dell Inc.          Vost=
ro 3360/0F5DWF, BIOS A18 09/25/2013
> =C4=8Den 18 23:12:02 spock kernel: Workqueue: events_freezable ieee80211_=
restart_work [mac80211]
> =C4=8Den 18 23:12:02 spock kernel: RIP: 0010:drv_remove_interface+0x11f/0=
x130 [mac80211]
> =C4=8Den 18 23:12:02 spock kernel: Code: a0 57 f0 c2 e9 4b ff ff ff 48 8b=
 86 78 04 00 00 48 8d b6 98 04 00 00 48 c7 c7 e8 ef f8 c0 48 85 c0 48 0f 45=
 f0 e8 99 2e fa c2 <0f> 0b 5b 5d 41 5c c3 66 2e 0f 1f 84 00 00 00 00 00 0f =
1f 44 00 00
> =C4=8Den 18 23:12:02 spock kernel: RSP: 0018:ffffa87c40403c80 EFLAGS: 000=
10282
> =C4=8Den 18 23:12:02 spock kernel: RAX: 0000000000000000 RBX: ffff9fe028f=
6e900 RCX: 0000000000000000
> =C4=8Den 18 23:12:02 spock kernel: RDX: 0000000000000001 RSI: 00000000000=
00082 RDI: 00000000ffffffff
> =C4=8Den 18 23:12:02 spock kernel: RBP: ffff9fe028379930 R08: 00000000000=
004c9 R09: 0000000000000001
> =C4=8Den 18 23:12:02 spock kernel: R10: 0000000000000001 R11: 00000000000=
06fc0 R12: ffff9fe028379000
> =C4=8Den 18 23:12:02 spock kernel: R13: ffff9fe028f6f4b8 R14: ffff9fe0283=
78ca0 R15: ffff9fe0283787e0
> =C4=8Den 18 23:12:02 spock kernel: FS:  0000000000000000(0000) GS:ffff9fe=
02f2c0000(0000) knlGS:0000000000000000
> =C4=8Den 18 23:12:02 spock kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000=
00080050033
> =C4=8Den 18 23:12:02 spock kernel: CR2: 00007f313b33a940 CR3: 000000012ea=
0a002 CR4: 00000000001706e0
> =C4=8Den 18 23:12:02 spock kernel: Call Trace:
> =C4=8Den 18 23:12:02 spock kernel:  ieee80211_do_stop+0x5af/0x8c0 [mac802=
11]
> =C4=8Den 18 23:12:02 spock kernel:  ieee80211_stop+0x16/0x20 [mac80211]
> =C4=8Den 18 23:12:02 spock kernel:  __dev_close_many+0xaa/0x120
> =C4=8Den 18 23:12:02 spock kernel:  dev_close_many+0xa1/0x2b0
> =C4=8Den 18 23:12:02 spock kernel:  dev_close+0x6d/0x90
> =C4=8Den 18 23:12:02 spock kernel:  cfg80211_shutdown_all_interfaces+0x71=
/0xd0 [cfg80211]
> =C4=8Den 18 23:12:02 spock kernel:  ieee80211_reconfig+0xa2/0x1700 [mac80=
211]
> =C4=8Den 18 23:12:02 spock kernel:  ieee80211_restart_work+0xb7/0xe0 [mac=
80211]
> =C4=8Den 18 23:12:02 spock kernel:  process_one_work+0x1d4/0x3c0
> =C4=8Den 18 23:12:02 spock kernel:  worker_thread+0x228/0x470
> =C4=8Den 18 23:12:02 spock kernel:  ? process_one_work+0x3c0/0x3c0
> =C4=8Den 18 23:12:02 spock kernel:  kthread+0x19c/0x1c0
> =C4=8Den 18 23:12:02 spock kernel:  ? __kthread_init_worker+0x30/0x30
> =C4=8Den 18 23:12:02 spock kernel:  ret_from_fork+0x35/0x40
> =C4=8Den 18 23:12:02 spock kernel: ---[ end trace e017bc3573bd9bf3 ]---
> =3D=3D=3D
>=20
> Do you still want me to try Felix's tree, or there's something else I
> can try?
>=20
> Thank you.
>=20
> --=20
>   Best regards,
>     Oleksandr Natalenko (post-factum)
>     Principal Software Maintenance Engineer
>=20

--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXu/I8gAKCRA6cBh0uS2t
rEE+AQDx2hkk63uLsc/7Sf4eS10jiA1EBJTJ7hpmpdXn7pyKeAD/boCIEhi1pO0i
IghcLeq0ZzD3ZEn9yGtAApA/AegTcwM=
=SJQj
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--
