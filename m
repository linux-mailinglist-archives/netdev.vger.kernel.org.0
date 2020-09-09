Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF8326370E
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 22:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729525AbgIIUHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 16:07:04 -0400
Received: from smtprelay0065.hostedemail.com ([216.40.44.65]:59318 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725772AbgIIUGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 16:06:54 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id B4D1D837F24A;
        Wed,  9 Sep 2020 20:06:47 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:355:379:857:960:966:968:973:988:989:1260:1277:1311:1313:1314:1345:1437:1461:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:1801:2194:2196:2198:2199:2200:2201:2393:2559:2562:2828:2898:3138:3139:3140:3141:3142:3865:3867:3868:3870:3871:4225:4250:4321:4385:4605:5007:6742:6743:7903:8603:8660:8957:9038:9592:10004:10848:11026:11232:11657:11914:12043:12294:12295:12296:12297:12438:12555:12679:12688:12712:12737:12760:12895:12986:13148:13161:13229:13230:13439:13972:14096:14097:14659:21080:21433:21451:21611:21627:21773:21774:21939:21987:21990:30012:30045:30046:30054:30055:30062:30070:30080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: tub60_4709e21270e0
X-Filterd-Recvd-Size: 50329
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed,  9 Sep 2020 20:06:40 +0000 (UTC)
Message-ID: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
Subject: [trivial PATCH] treewide: Convert switch/case fallthrough; to break;
From:   Joe Perches <joe@perches.com>
To:     LKML <linux-kernel@vger.kernel.org>,
        Jiri Kosina <trivial@kernel.org>
Cc:     Kees Cook <kees.cook@canonical.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-rdma@vger.kernel.org,
        iommu@lists.linux-foundation.org, dm-devel@redhat.com,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, intel-wired-lan@lists.osuosl.org,
        oss-drivers@netronome.com, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-nvme@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-scsi@vger.kernel.org,
        storagedev@microchip.com, sparclinux@vger.kernel.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-parisc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, bpf@vger.kernel.org,
        dccp@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-sctp@vger.kernel.org,
        alsa-devel <alsa-devel@alsa-project.org>
Date:   Wed, 09 Sep 2020 13:06:39 -0700
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fallthrough to a separate case/default label break; isn't very readable.

Convert pseudo-keyword fallthrough; statements to a simple break; when
the next label is case or default and the only statement in the next
label block is break;

Found using:

$ grep-2.5.4 -rP --include=*.[ch] -n "fallthrough;(\s*(case\s+\w+|default)\s*:\s*){1,7}break;" *

Miscellanea:

o Move or coalesce a couple label blocks above a default: block.

Signed-off-by: Joe Perches <joe@perches.com>
---

Compiled allyesconfig x86-64 only.
A few files for other arches were not compiled.

 arch/arm/mach-mmp/pm-pxa910.c                             |  2 +-
 arch/arm64/kvm/handle_exit.c                              |  2 +-
 arch/mips/kernel/cpu-probe.c                              |  2 +-
 arch/mips/math-emu/cp1emu.c                               |  2 +-
 arch/s390/pci/pci.c                                       |  2 +-
 crypto/tcrypt.c                                           |  4 ++--
 drivers/ata/sata_mv.c                                     |  2 +-
 drivers/atm/lanai.c                                       |  2 +-
 drivers/gpu/drm/i915/display/intel_sprite.c               |  2 +-
 drivers/gpu/drm/nouveau/nvkm/engine/disp/hdmi.c           |  2 +-
 drivers/hid/wacom_wac.c                                   |  2 +-
 drivers/i2c/busses/i2c-i801.c                             |  2 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c                    | 14 +++++++-------
 drivers/infiniband/ulp/rtrs/rtrs-srv.c                    |  6 +++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c               |  2 +-
 drivers/irqchip/irq-vic.c                                 |  4 ++--
 drivers/md/dm.c                                           |  2 +-
 drivers/media/dvb-frontends/drxd_hard.c                   |  2 +-
 drivers/media/i2c/ov5640.c                                |  2 +-
 drivers/media/i2c/ov6650.c                                |  5 ++---
 drivers/media/i2c/smiapp/smiapp-core.c                    |  2 +-
 drivers/media/i2c/tvp5150.c                               |  2 +-
 drivers/media/pci/ddbridge/ddbridge-core.c                |  2 +-
 drivers/media/usb/cpia2/cpia2_core.c                      |  2 +-
 drivers/mfd/iqs62x.c                                      |  3 +--
 drivers/mmc/host/atmel-mci.c                              |  2 +-
 drivers/mtd/nand/raw/nandsim.c                            |  2 +-
 drivers/net/ethernet/intel/e1000e/phy.c                   |  2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pf.c               |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq.c             |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c               |  2 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c               |  2 +-
 drivers/net/ethernet/intel/igb/e1000_phy.c                |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c            |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c             |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c            |  2 +-
 drivers/net/ethernet/intel/ixgbevf/vf.c                   |  2 +-
 drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c                 |  2 +-
 drivers/net/ethernet/sfc/falcon/farch.c                   |  2 +-
 drivers/net/ethernet/sfc/farch.c                          |  2 +-
 drivers/net/phy/adin.c                                    |  3 +--
 drivers/net/usb/pegasus.c                                 |  4 ++--
 drivers/net/usb/usbnet.c                                  |  2 +-
 drivers/net/wireless/ath/ath5k/eeprom.c                   |  2 +-
 drivers/net/wireless/mediatek/mt7601u/dma.c               |  8 ++++----
 drivers/nvme/host/core.c                                  | 12 ++++++------
 drivers/pcmcia/db1xxx_ss.c                                |  4 ++--
 drivers/power/supply/abx500_chargalg.c                    |  2 +-
 drivers/power/supply/charger-manager.c                    |  2 +-
 drivers/rtc/rtc-pcf85063.c                                |  2 +-
 drivers/s390/scsi/zfcp_fsf.c                              |  2 +-
 drivers/scsi/aic7xxx/aic79xx_core.c                       |  4 ++--
 drivers/scsi/aic94xx/aic94xx_tmf.c                        |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c                              |  2 +-
 drivers/scsi/smartpqi/smartpqi_init.c                     |  2 +-
 drivers/scsi/sr.c                                         |  2 +-
 drivers/tty/serial/sunsu.c                                |  2 +-
 drivers/tty/serial/sunzilog.c                             |  2 +-
 drivers/tty/vt/vt_ioctl.c                                 |  2 +-
 drivers/usb/dwc3/core.c                                   |  2 +-
 drivers/usb/gadget/legacy/inode.c                         |  2 +-
 drivers/usb/gadget/udc/pxa25x_udc.c                       |  4 ++--
 drivers/usb/host/ohci-hcd.c                               |  2 +-
 drivers/usb/isp1760/isp1760-hcd.c                         |  2 +-
 drivers/usb/musb/cppi_dma.c                               |  2 +-
 drivers/usb/phy/phy-fsl-usb.c                             |  2 +-
 drivers/video/fbdev/stifb.c                               |  2 +-
 fs/afs/yfsclient.c                                        |  8 ++++----
 fs/ceph/dir.c                                             |  2 +-
 fs/nfs/nfs4proc.c                                         |  2 +-
 fs/nfs_common/nfsacl.c                                    |  2 +-
 kernel/bpf/verifier.c                                     |  2 +-
 kernel/sched/topology.c                                   |  2 +-
 kernel/trace/trace_events_filter.c                        |  2 +-
 net/dccp/output.c                                         |  2 +-
 net/ipv4/ip_output.c                                      |  2 +-
 net/netfilter/nf_tables_api.c                             |  2 +-
 net/rxrpc/input.c                                         |  4 ++--
 net/sctp/outqueue.c                                       |  2 +-
 sound/soc/codecs/ak4613.c                                 |  2 +-
 sound/soc/codecs/jz4770.c                                 |  2 +-
 82 files changed, 109 insertions(+), 112 deletions(-)

diff --git a/arch/arm/mach-mmp/pm-pxa910.c b/arch/arm/mach-mmp/pm-pxa910.c
index 1d71d73c1862..dcf2482a9e6c 100644
--- a/arch/arm/mach-mmp/pm-pxa910.c
+++ b/arch/arm/mach-mmp/pm-pxa910.c
@@ -161,7 +161,7 @@ void pxa910_pm_enter_lowpower_mode(int state)
 		idle_cfg |= APMU_MOH_IDLE_CFG_MOH_PWRDWN;
 		idle_cfg |= APMU_MOH_IDLE_CFG_MOH_PWR_SW(3)
 			| APMU_MOH_IDLE_CFG_MOH_L2_PWR_SW(3);
-		fallthrough;
+		break;
 	case POWER_MODE_CORE_INTIDLE:
 		break;
 	}
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 5d690d60ccad..bf3d54b0a233 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -128,7 +128,7 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
 	switch (ESR_ELx_EC(esr)) {
 	case ESR_ELx_EC_WATCHPT_LOW:
 		run->debug.arch.far = vcpu->arch.fault.far_el2;
-		fallthrough;
+		break;
 	case ESR_ELx_EC_SOFTSTP_LOW:
 	case ESR_ELx_EC_BREAKPT_LOW:
 	case ESR_ELx_EC_BKPT32:
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index e2955f1f6316..6ddc70211a0f 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -1823,7 +1823,7 @@ static inline void cpu_probe_mips(struct cpuinfo_mips *c, unsigned int cpu)
 		fallthrough;
 	case CPU_I6400:
 		c->options |= MIPS_CPU_SHARED_FTLB_RAM;
-		fallthrough;
+		break;
 	default:
 		break;
 	}
diff --git a/arch/mips/math-emu/cp1emu.c b/arch/mips/math-emu/cp1emu.c
index 587cf1d115e8..9c8f8539ec5d 100644
--- a/arch/mips/math-emu/cp1emu.c
+++ b/arch/mips/math-emu/cp1emu.c
@@ -1224,7 +1224,7 @@ static int cop1Emulate(struct pt_regs *xcp, struct mips_fpu_struct *ctx,
 			case bctl_op:
 				if (cpu_has_mips_2_3_4_5_r)
 					likely = 1;
-				fallthrough;
+				break;
 			case bct_op:
 				break;
 			}
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 4b62d6b55024..5b1e412bbd32 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -743,7 +743,7 @@ void zpci_release_device(struct kref *kref)
 		zpci_cleanup_bus_resources(zdev);
 		zpci_bus_device_unregister(zdev);
 		zpci_destroy_iommu(zdev);
-		fallthrough;
+		break;
 	default:
 		break;
 	}
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index eea0f453cfb6..8aac5bc60f4c 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -2464,7 +2464,7 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		test_hash_speed("streebog512", sec,
 				generic_hash_speed_template);
 		if (mode > 300 && mode < 400) break;
-		fallthrough;
+		break;
 	case 399:
 		break;
 
@@ -2587,7 +2587,7 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
 		test_mb_ahash_speed("streebog512", sec,
 				    generic_hash_speed_template, num_mb);
 		if (mode > 400 && mode < 500) break;
-		fallthrough;
+		break;
 	case 499:
 		break;
 
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 664ef658a955..4d6cce2352bd 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -2044,7 +2044,7 @@ static enum ata_completion_errors mv_qc_prep(struct ata_queued_cmd *qc)
 	case ATA_PROT_DMA:
 		if (tf->command == ATA_CMD_DSM)
 			return AC_ERR_OK;
-		fallthrough;
+		break;
 	case ATA_PROT_NCQ:
 		break;	/* continue below */
 	case ATA_PROT_PIO:
diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index ac811cfa6843..972a6837a20e 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -2019,7 +2019,7 @@ static int lanai_normalize_ci(struct lanai_dev *lanai,
 	switch (*vpip) {
 		case ATM_VPI_ANY:
 			*vpip = 0;
-			fallthrough;
+			break;
 		case 0:
 			break;
 		default:
diff --git a/drivers/gpu/drm/i915/display/intel_sprite.c b/drivers/gpu/drm/i915/display/intel_sprite.c
index 5ac0dbf0e03d..35ac539cc2b1 100644
--- a/drivers/gpu/drm/i915/display/intel_sprite.c
+++ b/drivers/gpu/drm/i915/display/intel_sprite.c
@@ -2861,7 +2861,7 @@ static bool gen12_plane_format_mod_supported(struct drm_plane *_plane,
 	case I915_FORMAT_MOD_Y_TILED_GEN12_MC_CCS:
 		if (!gen12_plane_supports_mc_ccs(dev_priv, plane->id))
 			return false;
-		fallthrough;
+		break;
 	case DRM_FORMAT_MOD_LINEAR:
 	case I915_FORMAT_MOD_X_TILED:
 	case I915_FORMAT_MOD_Y_TILED:
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/hdmi.c b/drivers/gpu/drm/nouveau/nvkm/engine/disp/hdmi.c
index 1ccfc8314812..bc83cf098e25 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/hdmi.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/hdmi.c
@@ -71,7 +71,7 @@ void pack_hdmi_infoframe(struct packed_hdmi_infoframe *packed_frame,
 		fallthrough;
 	case 1:
 		header |= raw_frame[0];
-		fallthrough;
+		break;
 	case 0:
 		break;
 	}
diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 83dfec327c42..822dc15b59b6 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -3833,7 +3833,7 @@ int wacom_setup_touch_input_capabilities(struct input_dev *input_dev,
 	case MTTPC_B:
 	case TABLETPC2FG:
 		input_mt_init_slots(input_dev, features->touch_max, INPUT_MT_DIRECT);
-		fallthrough;
+		break;
 
 	case TABLETPC:
 	case TABLETPCE:
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index e32ef3f01fe8..b13b1cbcac29 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -1785,7 +1785,7 @@ static int i801_probe(struct pci_dev *dev, const struct pci_device_id *id)
 		fallthrough;
 	case PCI_DEVICE_ID_INTEL_82801CA_3:
 		priv->features |= FEATURE_HOST_NOTIFY;
-		fallthrough;
+		break;
 	case PCI_DEVICE_ID_INTEL_82801BA_2:
 	case PCI_DEVICE_ID_INTEL_82801AB_3:
 	case PCI_DEVICE_ID_INTEL_82801AA_3:
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 776e89231c52..55339cad408a 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -209,7 +209,7 @@ static bool __rtrs_clt_change_state(struct rtrs_clt_sess *sess,
 		switch (old_state) {
 		case RTRS_CLT_RECONNECTING:
 			changed = true;
-			fallthrough;
+			break;
 		default:
 			break;
 		}
@@ -220,7 +220,7 @@ static bool __rtrs_clt_change_state(struct rtrs_clt_sess *sess,
 		case RTRS_CLT_CONNECTING_ERR:
 		case RTRS_CLT_CLOSED:
 			changed = true;
-			fallthrough;
+			break;
 		default:
 			break;
 		}
@@ -229,7 +229,7 @@ static bool __rtrs_clt_change_state(struct rtrs_clt_sess *sess,
 		switch (old_state) {
 		case RTRS_CLT_CONNECTING:
 			changed = true;
-			fallthrough;
+			break;
 		default:
 			break;
 		}
@@ -238,7 +238,7 @@ static bool __rtrs_clt_change_state(struct rtrs_clt_sess *sess,
 		switch (old_state) {
 		case RTRS_CLT_CONNECTING:
 			changed = true;
-			fallthrough;
+			break;
 		default:
 			break;
 		}
@@ -250,7 +250,7 @@ static bool __rtrs_clt_change_state(struct rtrs_clt_sess *sess,
 		case RTRS_CLT_RECONNECTING:
 		case RTRS_CLT_CONNECTED:
 			changed = true;
-			fallthrough;
+			break;
 		default:
 			break;
 		}
@@ -259,7 +259,7 @@ static bool __rtrs_clt_change_state(struct rtrs_clt_sess *sess,
 		switch (old_state) {
 		case RTRS_CLT_CLOSING:
 			changed = true;
-			fallthrough;
+			break;
 		default:
 			break;
 		}
@@ -268,7 +268,7 @@ static bool __rtrs_clt_change_state(struct rtrs_clt_sess *sess,
 		switch (old_state) {
 		case RTRS_CLT_CLOSED:
 			changed = true;
-			fallthrough;
+			break;
 		default:
 			break;
 		}
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv.c b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
index b61a18e57aeb..24e53b39a79c 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv.c
@@ -78,7 +78,7 @@ static bool __rtrs_srv_change_state(struct rtrs_srv_sess *sess,
 		switch (old_state) {
 		case RTRS_SRV_CONNECTING:
 			changed = true;
-			fallthrough;
+			break;
 		default:
 			break;
 		}
@@ -88,7 +88,7 @@ static bool __rtrs_srv_change_state(struct rtrs_srv_sess *sess,
 		case RTRS_SRV_CONNECTING:
 		case RTRS_SRV_CONNECTED:
 			changed = true;
-			fallthrough;
+			break;
 		default:
 			break;
 		}
@@ -97,7 +97,7 @@ static bool __rtrs_srv_change_state(struct rtrs_srv_sess *sess,
 		switch (old_state) {
 		case RTRS_SRV_CLOSING:
 			changed = true;
-			fallthrough;
+			break;
 		default:
 			break;
 		}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index c192544e874b..743db1abec40 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3777,7 +3777,7 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 	switch (FIELD_GET(IDR0_TTF, reg)) {
 	case IDR0_TTF_AARCH32_64:
 		smmu->ias = 40;
-		fallthrough;
+		break;
 	case IDR0_TTF_AARCH64:
 		break;
 	default:
diff --git a/drivers/irqchip/irq-vic.c b/drivers/irqchip/irq-vic.c
index e46036374227..10ff0a5c225a 100644
--- a/drivers/irqchip/irq-vic.c
+++ b/drivers/irqchip/irq-vic.c
@@ -453,10 +453,10 @@ static void __init __vic_init(void __iomem *base, int parent_irq, int irq_start,
 	case AMBA_VENDOR_ST:
 		vic_init_st(base, irq_start, vic_sources, node);
 		return;
+	case AMBA_VENDOR_ARM:
+		break;
 	default:
 		printk(KERN_WARNING "VIC: unknown vendor, continuing anyways\n");
-		fallthrough;
-	case AMBA_VENDOR_ARM:
 		break;
 	}
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3dedd9cc4fb6..dc71573d5b09 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1021,7 +1021,7 @@ static void clone_endio(struct bio *bio)
 		switch (r) {
 		case DM_ENDIO_REQUEUE:
 			error = BLK_STS_DM_REQUEUE;
-			fallthrough;
+			break;
 		case DM_ENDIO_DONE:
 			break;
 		case DM_ENDIO_INCOMPLETE:
diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
index 45f982863904..d6592e764a92 100644
--- a/drivers/media/dvb-frontends/drxd_hard.c
+++ b/drivers/media/dvb-frontends/drxd_hard.c
@@ -1519,7 +1519,7 @@ static int SetDeviceTypeId(struct drxd_state *state)
 				break;
 			case 6:
 				state->diversity = 1;
-				fallthrough;
+				break;
 			case 5:
 			case 8:
 				break;
diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
index 637687d761f2..855d3aba711a 100644
--- a/drivers/media/i2c/ov5640.c
+++ b/drivers/media/i2c/ov5640.c
@@ -3010,7 +3010,7 @@ static int ov5640_probe(struct i2c_client *client)
 		switch (rotation) {
 		case 180:
 			sensor->upside_down = true;
-			fallthrough;
+			break;
 		case 0:
 			break;
 		default:
diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index d73f9f540932..fde56572dce8 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -685,17 +685,16 @@ static int ov6650_set_fmt(struct v4l2_subdev *sd,
 	switch (mf->code) {
 	case MEDIA_BUS_FMT_Y10_1X10:
 		mf->code = MEDIA_BUS_FMT_Y8_1X8;
-		fallthrough;
+		break;
 	case MEDIA_BUS_FMT_Y8_1X8:
 	case MEDIA_BUS_FMT_YVYU8_2X8:
 	case MEDIA_BUS_FMT_YUYV8_2X8:
 	case MEDIA_BUS_FMT_VYUY8_2X8:
 	case MEDIA_BUS_FMT_UYVY8_2X8:
+	case MEDIA_BUS_FMT_SBGGR8_1X8:
 		break;
 	default:
 		mf->code = MEDIA_BUS_FMT_SBGGR8_1X8;
-		fallthrough;
-	case MEDIA_BUS_FMT_SBGGR8_1X8:
 		break;
 	}
 
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 6fc0680a93d0..8bfba407b8f1 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2795,7 +2795,7 @@ static struct smiapp_hwconfig *smiapp_get_hwconfig(struct device *dev)
 		case 180:
 			hwcfg->module_board_orient =
 				SMIAPP_MODULE_BOARD_ORIENT_180;
-			fallthrough;
+			break;
 		case 0:
 			break;
 		default:
diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index 7d9401219a3a..df174089e74d 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -293,7 +293,7 @@ static void tvp5150_selmux(struct v4l2_subdev *sd)
 	switch (decoder->input) {
 	case TVP5150_COMPOSITE1:
 		input |= 2;
-		fallthrough;
+		break;
 	case TVP5150_COMPOSITE0:
 		break;
 	case TVP5150_SVIDEO:
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 92fe051c672f..426c9e0152d8 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1336,7 +1336,7 @@ static void dvb_input_detach(struct ddb_input *input)
 		fallthrough;
 	case 0x10:
 		dvb_dmx_release(&dvb->demux);
-		fallthrough;
+		break;
 	case 0x01:
 		break;
 	}
diff --git a/drivers/media/usb/cpia2/cpia2_core.c b/drivers/media/usb/cpia2/cpia2_core.c
index e747548ab286..cbef274d4f95 100644
--- a/drivers/media/usb/cpia2/cpia2_core.c
+++ b/drivers/media/usb/cpia2/cpia2_core.c
@@ -1751,7 +1751,7 @@ int cpia2_set_fps(struct camera_data *cam, int framerate)
 						    CPIA2_VP_SENSOR_FLAGS_500) {
 				return -EINVAL;
 			}
-			fallthrough;
+			break;
 		case CPIA2_VP_FRAMERATE_15:
 		case CPIA2_VP_FRAMERATE_12_5:
 		case CPIA2_VP_FRAMERATE_7_5:
diff --git a/drivers/mfd/iqs62x.c b/drivers/mfd/iqs62x.c
index 761b4ef3a381..5671482ec8fe 100644
--- a/drivers/mfd/iqs62x.c
+++ b/drivers/mfd/iqs62x.c
@@ -490,8 +490,7 @@ static irqreturn_t iqs62x_irq(int irq, void *context)
 
 		case IQS62X_EVENT_HYST:
 			event_map[i] <<= iqs62x->dev_desc->hyst_shift;
-
-			fallthrough;
+			break;
 
 		case IQS62X_EVENT_WHEEL:
 		case IQS62X_EVENT_HALL:
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 444bd3a0a922..8324312e4f42 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -2435,7 +2435,7 @@ static void atmci_get_cap(struct atmel_mci *host)
 	case 0x100:
 		host->caps.has_bad_data_ordering = 0;
 		host->caps.need_reset_after_xfer = 0;
-		fallthrough;
+		break;
 	case 0x0:
 		break;
 	default:
diff --git a/drivers/mtd/nand/raw/nandsim.c b/drivers/mtd/nand/raw/nandsim.c
index f5a53aac3c5f..b07934247297 100644
--- a/drivers/mtd/nand/raw/nandsim.c
+++ b/drivers/mtd/nand/raw/nandsim.c
@@ -2286,7 +2286,7 @@ static int __init ns_init_module(void)
 		fallthrough;
 	case 1:
 		chip->bbt_options |= NAND_BBT_USE_FLASH;
-		fallthrough;
+		break;
 	case 0:
 		break;
 	default:
diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
index e11c877595fb..9fec7cc52710 100644
--- a/drivers/net/ethernet/intel/e1000e/phy.c
+++ b/drivers/net/ethernet/intel/e1000e/phy.c
@@ -607,7 +607,7 @@ static s32 e1000_set_master_slave_mode(struct e1000_hw *hw)
 		break;
 	case e1000_ms_auto:
 		phy_data &= ~CTL1000_ENABLE_MASTER;
-		fallthrough;
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_pf.c b/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
index c0780c3624c8..1c601d7464dd 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_pf.c
@@ -1329,7 +1329,7 @@ static u8 fm10k_iov_supported_xcast_mode_pf(struct fm10k_vf_info *vf_info,
 	case FM10K_XCAST_MODE_NONE:
 		if (vf_flags & FM10K_VF_FLAG_NONE_CAPABLE)
 			return FM10K_XCAST_MODE_NONE;
-		fallthrough;
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq.c b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
index c897a2863e4f..857b699f02c9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq.c
@@ -541,7 +541,7 @@ static void i40e_set_hw_flags(struct i40e_hw *hw)
 		    (aq->api_maj_ver == 1 &&
 		     aq->api_min_ver >= I40E_MINOR_VER_GET_LINK_INFO_X722))
 			hw->flags |= I40E_HW_FLAG_AQ_PHY_ACCESS_CAPABLE;
-		fallthrough;
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 91ab824926b9..ef4f3dbc7b7e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -1690,7 +1690,7 @@ static inline void i40e_rx_checksum(struct i40e_vsi *vsi,
 	case I40E_RX_PTYPE_INNER_PROT_UDP:
 	case I40E_RX_PTYPE_INNER_PROT_SCTP:
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
-		fallthrough;
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 256fa07d54d5..c2c1ef255008 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1007,7 +1007,7 @@ static inline void iavf_rx_checksum(struct iavf_vsi *vsi,
 	case IAVF_RX_PTYPE_INNER_PROT_UDP:
 	case IAVF_RX_PTYPE_INNER_PROT_SCTP:
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
-		fallthrough;
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/intel/igb/e1000_phy.c b/drivers/net/ethernet/intel/igb/e1000_phy.c
index 8c8eb82e6272..f8f7ffbc45f0 100644
--- a/drivers/net/ethernet/intel/igb/e1000_phy.c
+++ b/drivers/net/ethernet/intel/igb/e1000_phy.c
@@ -2621,7 +2621,7 @@ static s32 igb_set_master_slave_mode(struct e1000_hw *hw)
 		break;
 	case e1000_ms_auto:
 		phy_data &= ~CR_1000T_MS_ENABLE;
-		fallthrough;
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
index 8d3798a32f0e..1549f0342384 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
@@ -1589,7 +1589,7 @@ s32 ixgbe_fdir_set_input_mask_82599(struct ixgbe_hw *hw,
 	case 0x0000:
 		/* Mask Flex Bytes */
 		fdirm |= IXGBE_FDIRM_FLEX;
-		fallthrough;
+		break;
 	case 0xFFFF:
 		break;
 	default:
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 0b675c34ce49..17e0fe4d380e 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -5901,7 +5901,7 @@ void ixgbe_disable_tx(struct ixgbe_adapter *adapter)
 		IXGBE_WRITE_REG(hw, IXGBE_DMATXCTL,
 				(IXGBE_READ_REG(hw, IXGBE_DMATXCTL) &
 				 ~IXGBE_DMATXCTL_TE));
-		fallthrough;
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index 988db46bff0e..45b18708f5ed 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -1141,7 +1141,7 @@ static int ixgbe_update_vf_xcast_mode(struct ixgbe_adapter *adapter,
 		/* promisc introduced in 1.3 version */
 		if (xcast_mode == IXGBEVF_XCAST_MODE_PROMISC)
 			return -EOPNOTSUPP;
-		fallthrough;
+		break;
 	case ixgbe_mbox_api_13:
 	case ixgbe_mbox_api_14:
 		break;
diff --git a/drivers/net/ethernet/intel/ixgbevf/vf.c b/drivers/net/ethernet/intel/ixgbevf/vf.c
index bfe6dfcec4ab..7f14665b6bdf 100644
--- a/drivers/net/ethernet/intel/ixgbevf/vf.c
+++ b/drivers/net/ethernet/intel/ixgbevf/vf.c
@@ -540,7 +540,7 @@ static s32 ixgbevf_update_xcast_mode(struct ixgbe_hw *hw, int xcast_mode)
 		/* promisc introduced in 1.3 version */
 		if (xcast_mode == IXGBEVF_XCAST_MODE_PROMISC)
 			return -EOPNOTSUPP;
-		fallthrough;
+		break;
 	case ixgbe_mbox_api_14:
 	case ixgbe_mbox_api_13:
 		break;
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
index 252fe06f58aa..1d5b87079104 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c
@@ -345,7 +345,7 @@ static int matching_bar(struct nfp_bar *bar, u32 tgt, u32 act, u32 tok,
 		baract = NFP_CPP_ACTION_RW;
 		if (act == 0)
 			act = NFP_CPP_ACTION_RW;
-		fallthrough;
+		break;
 	case NFP_PCIE_BAR_PCIE2CPP_MapType_FIXED:
 		break;
 	default:
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index cd882c453394..1bffe5cb88f4 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -3546,7 +3546,7 @@ qed_mcp_resc_allocation_msg(struct qed_hwfn *p_hwfn,
 	switch (p_in_params->cmd) {
 	case DRV_MSG_SET_RESOURCE_VALUE_MSG:
 		mfw_resc_info.size = p_in_params->resc_max_val;
-		fallthrough;
+		break;
 	case DRV_MSG_GET_RESOURCE_ALLOC_MSG:
 		break;
 	default:
diff --git a/drivers/net/ethernet/sfc/falcon/farch.c b/drivers/net/ethernet/sfc/falcon/farch.c
index fa1ade856b10..14f42c94809d 100644
--- a/drivers/net/ethernet/sfc/falcon/farch.c
+++ b/drivers/net/ethernet/sfc/falcon/farch.c
@@ -1052,7 +1052,7 @@ ef4_farch_handle_rx_event(struct ef4_channel *channel, const ef4_qword_t *event)
 			fallthrough;
 		case FSE_CZ_RX_EV_HDR_TYPE_IPV4V6_UDP:
 			flags |= EF4_RX_PKT_CSUMMED;
-			fallthrough;
+			break;
 		case FSE_CZ_RX_EV_HDR_TYPE_IPV4V6_OTHER:
 		case FSE_AZ_RX_EV_HDR_TYPE_OTHER:
 			break;
diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
index e004524e14a8..cea0eb822473 100644
--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -1038,7 +1038,7 @@ efx_farch_handle_rx_event(struct efx_channel *channel, const efx_qword_t *event)
 			fallthrough;
 		case FSE_CZ_RX_EV_HDR_TYPE_IPV4V6_UDP:
 			flags |= EFX_RX_PKT_CSUMMED;
-			fallthrough;
+			break;
 		case FSE_CZ_RX_EV_HDR_TYPE_IPV4V6_OTHER:
 		case FSE_AZ_RX_EV_HDR_TYPE_OTHER:
 			break;
diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 307f0ac1287b..95aeffe7482b 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -366,10 +366,9 @@ static int adin_set_edpd(struct phy_device *phydev, u16 tx_interval)
 
 	switch (tx_interval) {
 	case 1000: /* 1 second */
-		fallthrough;
 	case ETHTOOL_PHY_EDPD_DFLT_TX_MSECS:
 		val |= ADIN1300_NRG_PD_TX_EN;
-		fallthrough;
+		break;
 	case ETHTOOL_PHY_EDPD_NO_TX:
 		break;
 	default:
diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index e92cb51a2c77..9adb26ee4a86 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -627,10 +627,10 @@ static void write_bulk_callback(struct urb *urb)
 	case -ESHUTDOWN:
 		netif_dbg(pegasus, ifdown, net, "tx unlink, %d\n", status);
 		return;
+	case 0:
+		break;
 	default:
 		netif_info(pegasus, tx_err, net, "TX status %d\n", status);
-		fallthrough;
-	case 0:
 		break;
 	}
 
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 2b2a841cd938..56edd8c9819e 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -110,7 +110,7 @@ int usbnet_get_endpoints(struct usbnet *dev, struct usb_interface *intf)
 				if (!usb_endpoint_dir_in(&e->desc))
 					continue;
 				intr = 1;
-				fallthrough;
+				break;
 			case USB_ENDPOINT_XFER_BULK:
 				break;
 			default:
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 1fbc2c19848f..f5ea317f2a67 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -1178,7 +1178,7 @@ ath5k_cal_data_offset_2413(struct ath5k_eeprom_info *ee, int mode)
 			offset += ath5k_pdgains_size_2413(ee,
 					AR5K_EEPROM_MODE_11A) +
 					AR5K_EEPROM_N_5GHZ_CHAN / 2;
-		fallthrough;
+		break;
 	case AR5K_EEPROM_MODE_11A:
 		break;
 	default:
diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
index 09f931d4598c..778be26d329f 100644
--- a/drivers/net/wireless/mediatek/mt7601u/dma.c
+++ b/drivers/net/wireless/mediatek/mt7601u/dma.c
@@ -193,11 +193,11 @@ static void mt7601u_complete_rx(struct urb *urb)
 	case -ESHUTDOWN:
 	case -ENOENT:
 		return;
+	case 0:
+		break;
 	default:
 		dev_err_ratelimited(dev->dev, "rx urb failed: %d\n",
 				    urb->status);
-		fallthrough;
-	case 0:
 		break;
 	}
 
@@ -238,11 +238,11 @@ static void mt7601u_complete_tx(struct urb *urb)
 	case -ESHUTDOWN:
 	case -ENOENT:
 		return;
+	case 0:
+		break;
 	default:
 		dev_err_ratelimited(dev->dev, "tx urb failed: %d\n",
 				    urb->status);
-		fallthrough;
-	case 0:
 		break;
 	}
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index ea1fa41fbba8..aea9f978861e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -365,7 +365,7 @@ bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 		case NVME_CTRL_RESETTING:
 		case NVME_CTRL_CONNECTING:
 			changed = true;
-			fallthrough;
+			break;
 		default:
 			break;
 		}
@@ -375,7 +375,7 @@ bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 		case NVME_CTRL_NEW:
 		case NVME_CTRL_LIVE:
 			changed = true;
-			fallthrough;
+			break;
 		default:
 			break;
 		}
@@ -385,7 +385,7 @@ bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 		case NVME_CTRL_NEW:
 		case NVME_CTRL_RESETTING:
 			changed = true;
-			fallthrough;
+			break;
 		default:
 			break;
 		}
@@ -396,7 +396,7 @@ bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 		case NVME_CTRL_RESETTING:
 		case NVME_CTRL_CONNECTING:
 			changed = true;
-			fallthrough;
+			break;
 		default:
 			break;
 		}
@@ -406,7 +406,7 @@ bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 		case NVME_CTRL_DELETING:
 		case NVME_CTRL_DEAD:
 			changed = true;
-			fallthrough;
+			break;
 		default:
 			break;
 		}
@@ -415,7 +415,7 @@ bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 		switch (old_state) {
 		case NVME_CTRL_DELETING:
 			changed = true;
-			fallthrough;
+			break;
 		default:
 			break;
 		}
diff --git a/drivers/pcmcia/db1xxx_ss.c b/drivers/pcmcia/db1xxx_ss.c
index a7c7c7cd2326..d5eec00aaf97 100644
--- a/drivers/pcmcia/db1xxx_ss.c
+++ b/drivers/pcmcia/db1xxx_ss.c
@@ -258,7 +258,7 @@ static int db1x_pcmcia_configure(struct pcmcia_socket *skt,
 		fallthrough;
 	case 33:
 		++v;
-		fallthrough;
+		break;
 	case 0:
 		break;
 	default:
@@ -273,7 +273,7 @@ static int db1x_pcmcia_configure(struct pcmcia_socket *skt,
 	case 33:
 	case 50:
 		++p;
-		fallthrough;
+		break;
 	case 0:
 		break;
 	default:
diff --git a/drivers/power/supply/abx500_chargalg.c b/drivers/power/supply/abx500_chargalg.c
index 175c4f3d7955..b847a1570ab0 100644
--- a/drivers/power/supply/abx500_chargalg.c
+++ b/drivers/power/supply/abx500_chargalg.c
@@ -1419,7 +1419,7 @@ static void abx500_chargalg_algorithm(struct abx500_chargalg *di)
 		abx500_chargalg_stop_charging(di);
 		di->charge_status = POWER_SUPPLY_STATUS_DISCHARGING;
 		abx500_chargalg_state_to(di, STATE_HANDHELD);
-		fallthrough;
+		break;
 
 	case STATE_HANDHELD:
 		break;
diff --git a/drivers/power/supply/charger-manager.c b/drivers/power/supply/charger-manager.c
index 07992821e252..ac7871a7684b 100644
--- a/drivers/power/supply/charger-manager.c
+++ b/drivers/power/supply/charger-manager.c
@@ -585,7 +585,7 @@ static int cm_get_target_status(struct charger_manager *cm)
 	case POWER_SUPPLY_STATUS_FULL:
 		if (is_full_charged(cm))
 			return POWER_SUPPLY_STATUS_FULL;
-		fallthrough;
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/rtc/rtc-pcf85063.c b/drivers/rtc/rtc-pcf85063.c
index f8b99cb72959..65bb87cc8380 100644
--- a/drivers/rtc/rtc-pcf85063.c
+++ b/drivers/rtc/rtc-pcf85063.c
@@ -353,7 +353,7 @@ static int pcf85063_load_capacitance(struct pcf85063 *pcf85063,
 	default:
 		dev_warn(&pcf85063->rtc->dev, "Unknown quartz-load-femtofarads value: %d. Assuming 7000",
 			 load);
-		fallthrough;
+		break;
 	case 7000:
 		break;
 	case 12500:
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 140186fe1d1e..2741a07df692 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2105,7 +2105,7 @@ static void zfcp_fsf_open_lun_handler(struct zfcp_fsf_req *req)
 
 	case FSF_PORT_HANDLE_NOT_VALID:
 		zfcp_erp_adapter_reopen(adapter, 0, "fsouh_1");
-		fallthrough;
+		break;
 	case FSF_LUN_ALREADY_OPEN:
 		break;
 	case FSF_PORT_BOXED:
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 1c617c0d5899..e8fa68d96cde 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -8175,7 +8175,7 @@ ahd_search_qinfifo(struct ahd_softc *ahd, int target, char channel,
 				if ((scb->flags & SCB_ACTIVE) == 0)
 					printk("Inactive SCB in qinfifo\n");
 				ahd_done_with_status(ahd, scb, status);
-				fallthrough;
+				break;
 			case SEARCH_REMOVE:
 				break;
 			case SEARCH_PRINT:
@@ -8295,7 +8295,7 @@ ahd_search_qinfifo(struct ahd_softc *ahd, int target, char channel,
 			}
 			case SEARCH_PRINT:
 				printk(" 0x%x", SCB_GET_TAG(scb));
-				fallthrough;
+				break;
 			case SEARCH_COUNT:
 				break;
 			}
diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index 0eb6e206a2b4..fdd0f34fcb17 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -490,7 +490,7 @@ int asd_abort_task(struct sas_task *task)
 		switch (tcs.dl_opcode) {
 		default:
 			res = asd_clear_nexus(task);
-			fallthrough;
+			break;
 		case TC_NO_ERROR:
 			break;
 			/* The task hasn't been sent to the device xor
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index e158cd77d387..253a4a41ebc9 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -9339,7 +9339,7 @@ __lpfc_sli_issue_iocb_s3(struct lpfc_hba *phba, uint32_t ring_number,
 			 */
 			if (piocb->iocb_cmpl)
 				piocb->iocb_cmpl = NULL;
-			fallthrough;
+			break;
 		case CMD_CREATE_XRI_CR:
 		case CMD_CLOSE_XRI_CN:
 		case CMD_CLOSE_XRI_CX:
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 9d0229656681..f2be6feea226 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -2937,7 +2937,7 @@ static int pqi_process_io_intr(struct pqi_ctrl_info *ctrl_info, struct pqi_queue
 		case PQI_RESPONSE_IU_AIO_PATH_IO_SUCCESS:
 			if (io_request->scmd)
 				io_request->scmd->result = 0;
-			fallthrough;
+			break;
 		case PQI_RESPONSE_IU_GENERAL_MANAGEMENT:
 			break;
 		case PQI_RESPONSE_IU_VENDOR_GENERAL:
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 3b3a53c6a0de..1216396284f9 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -880,7 +880,7 @@ static void get_sectorsize(struct scsi_cd *cd)
 			fallthrough;
 		case 2048:
 			cd->capacity *= 4;
-			fallthrough;
+			break;
 		case 512:
 			break;
 		default:
diff --git a/drivers/tty/serial/sunsu.c b/drivers/tty/serial/sunsu.c
index 319e5ceb6130..de3fbdcfa7f8 100644
--- a/drivers/tty/serial/sunsu.c
+++ b/drivers/tty/serial/sunsu.c
@@ -514,7 +514,7 @@ static void receive_kbd_ms_chars(struct uart_sunsu_port *up, int is_break)
 			switch (ret) {
 			case 2:
 				sunsu_change_mouse_baud(up);
-				fallthrough;
+				break;
 			case 1:
 				break;
 
diff --git a/drivers/tty/serial/sunzilog.c b/drivers/tty/serial/sunzilog.c
index 001e19d7c17d..a1f5c73be291 100644
--- a/drivers/tty/serial/sunzilog.c
+++ b/drivers/tty/serial/sunzilog.c
@@ -306,7 +306,7 @@ static void sunzilog_kbdms_receive_chars(struct uart_sunzilog_port *up,
 		switch (ret) {
 		case 2:
 			sunzilog_change_mouse_baud(up);
-			fallthrough;
+			break;
 		case 1:
 			break;
 
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 2ea76a09e07f..c7ca691f1d2b 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -255,7 +255,7 @@ static int vt_kdsetmode(struct vc_data *vc, unsigned long mode)
 	case KD_TEXT0:
 	case KD_TEXT1:
 		mode = KD_TEXT;
-		fallthrough;
+		break;
 	case KD_TEXT:
 		break;
 	default:
diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 2eb34c8b4065..85f04dca7ae9 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -646,7 +646,7 @@ static int dwc3_phy_setup(struct dwc3 *dwc)
 			if (!(reg & DWC3_GUSB2PHYCFG_ULPI_UTMI))
 				break;
 		}
-		fallthrough;
+		break;
 	case DWC3_GHWPARAMS3_HSPHY_IFC_ULPI:
 	default:
 		break;
diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index 1b430b36d0a6..261ec2dd52c6 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1717,7 +1717,7 @@ gadgetfs_suspend (struct usb_gadget *gadget)
 	case STATE_DEV_UNCONNECTED:
 		next_event (dev, GADGETFS_SUSPEND);
 		ep0_readable (dev);
-		fallthrough;
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/usb/gadget/udc/pxa25x_udc.c b/drivers/usb/gadget/udc/pxa25x_udc.c
index 10324a7334fe..a5a754ba6bc9 100644
--- a/drivers/usb/gadget/udc/pxa25x_udc.c
+++ b/drivers/usb/gadget/udc/pxa25x_udc.c
@@ -2340,12 +2340,12 @@ static int pxa25x_udc_probe(struct platform_device *pdev)
 	case PXA250_A0:
 	case PXA250_A1:
 		/* A0/A1 "not released"; ep 13, 15 unusable */
-		fallthrough;
+		break;
 	case PXA250_B2: case PXA210_B2:
 	case PXA250_B1: case PXA210_B1:
 	case PXA250_B0: case PXA210_B0:
 		/* OUT-DMA is broken ... */
-		fallthrough;
+		break;
 	case PXA250_C0: case PXA210_C0:
 		break;
 #elif	defined(CONFIG_ARCH_IXP4XX)
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index dd37e77dae00..9ea59b99535e 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -1051,7 +1051,7 @@ int ohci_restart(struct ohci_hcd *ohci)
 			ed->ed_next = ohci->ed_rm_list;
 			ed->ed_prev = NULL;
 			ohci->ed_rm_list = ed;
-			fallthrough;
+			break;
 		case ED_UNLINK:
 			break;
 		default:
diff --git a/drivers/usb/isp1760/isp1760-hcd.c b/drivers/usb/isp1760/isp1760-hcd.c
index dd74ab7a2f9c..30c168bccf70 100644
--- a/drivers/usb/isp1760/isp1760-hcd.c
+++ b/drivers/usb/isp1760/isp1760-hcd.c
@@ -792,7 +792,7 @@ static void collect_qtds(struct usb_hcd *hcd, struct isp1760_qh *qh,
 				case OUT_PID:
 					qtd->urb->actual_length +=
 							qtd->actual_length;
-					fallthrough;
+					break;
 				case SETUP_PID:
 					break;
 				}
diff --git a/drivers/usb/musb/cppi_dma.c b/drivers/usb/musb/cppi_dma.c
index edb5b63d7063..a066aec2b4c1 100644
--- a/drivers/usb/musb/cppi_dma.c
+++ b/drivers/usb/musb/cppi_dma.c
@@ -975,7 +975,7 @@ static int cppi_channel_program(struct dma_channel *ch,
 		musb_dbg(musb, "%cX DMA%d not allocated!",
 				cppi_ch->transmit ? 'T' : 'R',
 				cppi_ch->index);
-		fallthrough;
+		break;
 	case MUSB_DMA_STATUS_FREE:
 		break;
 	}
diff --git a/drivers/usb/phy/phy-fsl-usb.c b/drivers/usb/phy/phy-fsl-usb.c
index f34c9437a182..d5c3b548aa51 100644
--- a/drivers/usb/phy/phy-fsl-usb.c
+++ b/drivers/usb/phy/phy-fsl-usb.c
@@ -914,7 +914,7 @@ int usb_otg_start(struct platform_device *pdev)
 		fallthrough;
 	case FSL_USB2_PHY_UTMI:
 		temp |= PORTSC_PTS_UTMI;
-		fallthrough;
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/video/fbdev/stifb.c b/drivers/video/fbdev/stifb.c
index 265865610edc..aae5ca0b89c9 100644
--- a/drivers/video/fbdev/stifb.c
+++ b/drivers/video/fbdev/stifb.c
@@ -1157,7 +1157,7 @@ static int __init stifb_init_fb(struct sti_struct *sti, int bpp_pref)
 			dev_name);
 		   goto out_err0;
 		}
-		fallthrough;
+		break;
 	case S9000_ID_ARTIST:
 	case S9000_ID_HCRX:
 	case S9000_ID_TIMBER:
diff --git a/fs/afs/yfsclient.c b/fs/afs/yfsclient.c
index 3b1239b7e90d..6be481a98097 100644
--- a/fs/afs/yfsclient.c
+++ b/fs/afs/yfsclient.c
@@ -461,7 +461,7 @@ static int yfs_deliver_fs_fetch_data64(struct afs_call *call)
 		req->file_size = vp->scb.status.size;
 
 		call->unmarshall++;
-		fallthrough;
+		break;
 
 	case 5:
 		break;
@@ -1363,7 +1363,7 @@ static int yfs_deliver_fs_get_volume_status(struct afs_call *call)
 		_debug("motd '%s'", p);
 
 		call->unmarshall++;
-		fallthrough;
+		break;
 
 	case 8:
 		break;
@@ -1727,7 +1727,7 @@ static int yfs_deliver_fs_inline_bulk_status(struct afs_call *call)
 		xdr_decode_YFSVolSync(&bp, &op->volsync);
 
 		call->unmarshall++;
-		fallthrough;
+		break;
 
 	case 6:
 		break;
@@ -1886,7 +1886,7 @@ static int yfs_deliver_fs_fetch_opaque_acl(struct afs_call *call)
 		xdr_decode_YFSVolSync(&bp, &op->volsync);
 
 		call->unmarshall++;
-		fallthrough;
+		break;
 
 	case 6:
 		break;
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index d72e4a12bb69..67c3005fb88d 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1740,7 +1740,7 @@ static int ceph_d_revalidate(struct dentry *dentry, unsigned int flags)
 			case -ENOENT:
 				if (d_really_is_negative(dentry))
 					valid = 1;
-				fallthrough;
+				break;
 			default:
 				break;
 			}
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 6e95c85fe395..4bf60dcf13e1 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -9444,7 +9444,7 @@ static void nfs4_layoutreturn_done(struct rpc_task *task, void *calldata)
 		fallthrough;
 	default:
 		task->tk_status = 0;
-		fallthrough;
+		break;
 	case 0:
 		break;
 	case -NFS4ERR_DELAY:
diff --git a/fs/nfs_common/nfsacl.c b/fs/nfs_common/nfsacl.c
index d056ad2fdefd..009c1e434aa5 100644
--- a/fs/nfs_common/nfsacl.c
+++ b/fs/nfs_common/nfsacl.c
@@ -237,7 +237,7 @@ posix_acl_from_nfsacl(struct posix_acl *acl)
 				break;
 			case ACL_MASK:
 				mask = pa;
-				fallthrough;
+				break;
 			case ACL_OTHER:
 				break;
 		}
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 86fdebb5ffd8..c88c7a7d77fb 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5334,7 +5334,7 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 				off_reg == dst_reg ? dst : src);
 			return -EACCES;
 		}
-		fallthrough;
+		break;
 	default:
 		break;
 	}
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index da3cd60e4b78..c6c8699f466c 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1233,7 +1233,7 @@ static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
 		fallthrough;
 	case sa_sd_storage:
 		__sdt_free(cpu_map);
-		fallthrough;
+		break;
 	case sa_none:
 		break;
 	}
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 78a678eeb140..52df27e45843 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1273,7 +1273,7 @@ static int parse_pred(const char *str, void *data,
 		switch (op) {
 		case OP_NE:
 			pred->not = 1;
-			fallthrough;
+			break;
 		case OP_GLOB:
 		case OP_EQ:
 			break;
diff --git a/net/dccp/output.c b/net/dccp/output.c
index 50e6d5699bb2..5a4dbd7cee32 100644
--- a/net/dccp/output.c
+++ b/net/dccp/output.c
@@ -62,7 +62,7 @@ static int dccp_transmit_skb(struct sock *sk, struct sk_buff *skb)
 		switch (dcb->dccpd_type) {
 		case DCCP_PKT_DATA:
 			set_ack = 0;
-			fallthrough;
+			break;
 		case DCCP_PKT_DATAACK:
 		case DCCP_PKT_RESET:
 			break;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 825e381e9909..3cf38c0bedf3 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -333,7 +333,7 @@ static int ip_mc_finish_output(struct net *net, struct sock *sk,
 	switch (ret) {
 	case NET_XMIT_CN:
 		do_cn = true;
-		fallthrough;
+		break;
 	case NET_XMIT_SUCCESS:
 		break;
 	default:
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 97fb6f776114..4844781699d5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8525,7 +8525,7 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 		default:
 			return -EINVAL;
 		}
-		fallthrough;
+		break;
 	case NFT_CONTINUE:
 	case NFT_BREAK:
 	case NFT_RETURN:
diff --git a/net/rxrpc/input.c b/net/rxrpc/input.c
index 667c44aa5a63..b654b8c65d10 100644
--- a/net/rxrpc/input.c
+++ b/net/rxrpc/input.c
@@ -1101,7 +1101,7 @@ static void rxrpc_input_implicit_end_call(struct rxrpc_sock *rx,
 	switch (READ_ONCE(call->state)) {
 	case RXRPC_CALL_SERVER_AWAIT_ACK:
 		rxrpc_call_completed(call);
-		fallthrough;
+		break;
 	case RXRPC_CALL_COMPLETE:
 		break;
 	default:
@@ -1265,7 +1265,7 @@ int rxrpc_input_packet(struct sock *udp_sk, struct sk_buff *skb)
 	case RXRPC_PACKET_TYPE_ACKALL:
 		if (sp->hdr.callNumber == 0)
 			goto bad_message;
-		fallthrough;
+		break;
 	case RXRPC_PACKET_TYPE_ABORT:
 		break;
 
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index 3fd06a27105d..f8ce1b3925a9 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -1030,7 +1030,7 @@ static void sctp_outq_flush_data(struct sctp_flush_ctx *ctx,
 		if (!ctx->packet || !ctx->packet->has_cookie_echo)
 			return;
 
-		fallthrough;
+		break;
 	case SCTP_STATE_ESTABLISHED:
 	case SCTP_STATE_SHUTDOWN_PENDING:
 	case SCTP_STATE_SHUTDOWN_RECEIVED:
diff --git a/sound/soc/codecs/ak4613.c b/sound/soc/codecs/ak4613.c
index 8d663e8d64c4..b35193eb9057 100644
--- a/sound/soc/codecs/ak4613.c
+++ b/sound/soc/codecs/ak4613.c
@@ -457,7 +457,7 @@ static int ak4613_set_bias_level(struct snd_soc_component *component,
 		fallthrough;
 	case SND_SOC_BIAS_STANDBY:
 		mgmt1 |= PMVR;
-		fallthrough;
+		break;
 	case SND_SOC_BIAS_OFF:
 	default:
 		break;
diff --git a/sound/soc/codecs/jz4770.c b/sound/soc/codecs/jz4770.c
index 298689a07168..734cf7809b7e 100644
--- a/sound/soc/codecs/jz4770.c
+++ b/sound/soc/codecs/jz4770.c
@@ -202,7 +202,7 @@ static int jz4770_codec_set_bias_level(struct snd_soc_component *codec,
 				   REG_CR_VIC_SB_SLEEP, REG_CR_VIC_SB_SLEEP);
 		regmap_update_bits(regmap, JZ4770_CODEC_REG_CR_VIC,
 				   REG_CR_VIC_SB, REG_CR_VIC_SB);
-		fallthrough;
+		break;
 	default:
 		break;
 	}


