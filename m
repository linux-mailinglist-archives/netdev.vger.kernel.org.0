Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2233FAD7B
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 19:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhH2Rll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 13:41:41 -0400
Received: from smtprelay0131.hostedemail.com ([216.40.44.131]:38060 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229665AbhH2Rlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 13:41:40 -0400
Received: from omf19.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id B923A18027C9F;
        Sun, 29 Aug 2021 17:40:46 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf19.hostedemail.com (Postfix) with ESMTPA id 66BFF20D75C;
        Sun, 29 Aug 2021 17:40:45 +0000 (UTC)
Message-ID: <26dc72d60681346bf6db245a649b7e049e125d74.camel@perches.com>
Subject: Re: [PATCH][next] igc: remove redundant continue statement
From:   Joe Perches <joe@perches.com>
To:     Colin King <colin.king@canonical.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sun, 29 Aug 2021 10:40:44 -0700
In-Reply-To: <20210829165150.531678-1-colin.king@canonical.com>
References: <20210829165150.531678-1-colin.king@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 66BFF20D75C
X-Stat-Signature: j6to1aadtpf6rbmut9wqbdy98ukofpuf
X-Spam-Status: No, score=-2.88
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+PkvHXoZZ9biqHpZEZ8UQ0r++6zlQvJLM=
X-HE-Tag: 1630258845-918920
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2021-08-29 at 17:51 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The continue statement at the end of a for-loop has no effect,
> remove it.

There seem to be a few of this type of use in the kernel.

Many are in switch {} default: continue uses inside loops where there
is no additional statement after the switch statement ends.

The continue is obviously safe and even perhaps preferred as statements
_might_ be added after the switch end or test/continue use.

But perhaps those should be converted to break;

For instance: drivers/gpu/drm/zte/zx_vou.c

static void zx_overlay_init(struct drm_device *drm, struct zx_vou_hw *vou)
{
	struct device *dev = vou->dev;
	struct zx_plane *zplane;
	int i;
	int ret;

	/*
	 * VL0 has some quirks on scaling support which need special handling.
	 * Let's leave it out for now.
	 */
	for (i = 1; i < VL_NUM; i++) {
		zplane = devm_kzalloc(dev, sizeof(*zplane), GFP_KERNEL);
		if (!zplane) {
			DRM_DEV_ERROR(dev, "failed to allocate zplane %d\n", i);
			return;
		}

		zplane->layer = vou->osd + OSD_VL_OFFSET(i);
		zplane->hbsc = vou->osd + HBSC_VL_OFFSET(i);
		zplane->rsz = vou->otfppu + RSZ_VL_OFFSET(i);
		zplane->bits = &zx_vl_bits[i];

		ret = zx_plane_init(drm, zplane, DRM_PLANE_TYPE_OVERLAY);
		if (ret) {
			DRM_DEV_ERROR(dev, "failed to init overlay %d\n", i);
			continue;
		}
	}
}

Here's a grep using grep version 2.5.4 that finds these
(with some false positives)

$ grep-2.5.4 -rP --include=*.[ch] -n '\t{3,3}continue;\n\t{2,2}\}\n\t{1,1}\}' *
arch/x86/events/intel/core.c:3408:			continue;
		}
	}
arch/arm/mach-at91/pm.c:801:			continue;
		}
	}
arch/powerpc/xmon/xmon.c:973:			continue;
		}
	}
arch/powerpc/platforms/ps3/mm.c:450:			continue;
		}
	}
arch/powerpc/platforms/powernv/opal-irqchip.c:286:			continue;
		}
	}
drivers/net/vxlan.c:807:			continue;
		}
	}
drivers/net/hamradio/6pack.c:450:			continue;
		}
	}
drivers/net/wireless/ath/ath11k/mac.c:5369:			continue;
		}
	}
drivers/net/wireless/ath/ath11k/mac.c:5403:			continue;
		}
	}
drivers/net/wireless/ath/ath10k/mac.c:8646:			continue;
		}
	}
drivers/net/wireless/ath/ath10k/mac.c:8687:			continue;
		}
	}
drivers/net/geneve.c:513:			continue;
		}
	}
drivers/net/ethernet/ti/netcp_core.c:331:			continue;
		}
	}
drivers/net/ethernet/neterion/s2io.c:1392:			continue;
		}
	}
drivers/net/ethernet/toshiba/ps3_gelic_wireless.c:1722:				continue;
		}
	}
drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:1633:			continue;
		}
	}
drivers/net/ethernet/intel/ixgbe/ixgbe_main.c:9386:				continue;
		}
	}
drivers/target/iscsi/iscsi_target_erl1.c:341:			continue;
		}
	}
drivers/cpufreq/powernow-k8.c:848:			continue;
		}
	}
drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c:3179:			continue;
		}
	}
drivers/iommu/intel/iommu.c:3082:			continue;
		}
	}
drivers/soc/ti/knav_qmss_queue.c:724:			continue;
		}
	}
drivers/mmc/host/vub300.c:561:			continue;
		}
	}
drivers/mmc/host/vub300.c:1885:			continue;
		}
	}
drivers/staging/rtl8188eu/core/rtw_efuse.c:552:			continue;
		}
	}
drivers/staging/greybus/audio_helper.c:184:			continue;
		}
	}
drivers/block/rbd.c:2443:			continue;
		}
	}
drivers/clk/sunxi/clk-sun8i-bus-gates.c:89:			continue;
		}
	}
drivers/clk/sunxi/clk-mod0.c:348:			continue;
		}
	}
drivers/pci/controller/pci-hyperv.c:2056:			continue;
		}
	}
drivers/scsi/mvumi.c:1595:				continue;
		}
	}
drivers/scsi/fnic/fnic_fcs.c:654:			continue;
		}
	}
drivers/scsi/qla4xxx/ql4_os.c:2795:			continue;
		}
	}
drivers/scsi/megaraid/megaraid_mm.c:545:			continue;
		}
	}
drivers/scsi/libsas/sas_expander.c:1202:			continue;
		}
	}
drivers/usb/typec/tcpm/tcpm.c:3236:			continue;
		}
	}
drivers/usb/host/fotg210-hcd.c:504:			continue;
		}
	}
drivers/usb/host/ehci-dbg.c:610:			continue;
		}
	}
drivers/usb/host/ohci-at91.c:549:			continue;
		}
	}
drivers/usb/serial/mos7840.c:539:			continue;
		}
	}
drivers/zorro/zorro.c:212:			continue;
		}
	}
drivers/iio/dac/ad5592r-base.c:561:			continue;
		}
	}
drivers/infiniband/hw/hfi1/init.c:1023:				continue;
		}
	}
drivers/char/agp/isoch.c:377:				continue;
		}
	}
drivers/gpu/drm/zte/zx_vou.c:666:			continue;
		}
	}
drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c:10133:			continue;
		}
	}
drivers/gpu/drm/nouveau/nvkm/subdev/i2c/base.c:360:			continue;
		}
	}
drivers/tty/serial/jsm/jsm_neo.c:1227:			continue;
		}
	}
drivers/platform/x86/sony-laptop.c:1413:			continue;
		}
	}
drivers/platform/x86/sony-laptop.c:1494:			continue;
		}
	}
drivers/platform/x86/sony-laptop.c:1532:			continue;
		}
	}
drivers/spi/spi-fsi.c:438:			continue;
		}
	} while (seq_state && (seq_state != SPI_FSI_STATUS_SEQ_STATE_IDLE));
drivers/comedi/drivers/ni_usb6501.c:497:			continue;
		}
	}
drivers/comedi/drivers/vmk80xx.c:663:			continue;
		}
	}
drivers/video/fbdev/core/fbcon.c:508:			continue;
		}
	}
drivers/mtd/ubi/block.c:640:			continue;
		}
	}
drivers/mtd/nand/raw/davinci_nand.c:337:			continue;
		}
	}
drivers/mtd/parsers/bcm47xxpart.c:248:			continue;
		}
	}
drivers/nvdimm/badrange.c:158:			continue;
		}
	}
drivers/isdn/hardware/mISDN/hfcsusb.c:1927:			continue;
		}
	}
drivers/input/joystick/grip.c:316:			continue;
		}
	}
drivers/greybus/interface.c:1148:			continue;
		}
	}
drivers/i2c/busses/i2c-powermac.c:366:			continue;
		}
	}
drivers/pinctrl/pinctrl-zynq.c:1101:			continue;
		}
	}
drivers/pinctrl/pinctrl-at91-pio4.c:895:			continue;
		}
	}
drivers/bluetooth/btusb.c:1658:			continue;
		}
	}
drivers/bluetooth/btusb.c:4302:			continue;
		}
	}
drivers/bluetooth/btusb.c:4519:			continue;
		}
	}
drivers/acpi/processor_perflib.c:617:			continue;
		}
	}
drivers/leds/leds-da9052.c:139:			continue;
		}
	}
fs/xfs/libxfs/xfs_sb.c:906:			continue;
		}
	}
fs/9p/v9fs.c:369:			continue;
		}
	}
fs/unicode/mkutf8data.c:1972:			continue;
		}
	}
fs/unicode/mkutf8data.c:2032:			continue;
		}
	}
fs/unicode/mkutf8data.c:2087:			continue;
		}
	}
fs/unicode/mkutf8data.c:2285:			continue;
		}
	}
fs/ocfs2/buffer_head_io.c:332:			continue;
		}
	}
kernel/bpf/syscall.c:3432:			continue;
		}
	}
kernel/range.c:109:			continue;
		}
	}
kernel/trace/trace_events.c:2626:			continue;
		}
	}
lib/test_rhashtable.c:437:				continue;
		}
	}
net/dsa/dsa2.c:831:			continue;
		}
	}
net/wireless/util.c:942:			continue;
		}
	}
net/9p/client.c:214:			continue;
		}
	}
net/9p/trans_fd.c:805:			continue;
		}
	}
net/9p/trans_rdma.c:232:			continue;
		}
	}
net/ipv4/fou.c:422:			continue;
		}
	}
net/ipv4/udp_offload.c:557:			continue;
		}
	}
net/ethernet/eth.c:438:			continue;
		}
	}
net/tipc/name_distr.c:358:			continue;
		}
	}
samples/seccomp/bpf-helper.c:57:			continue;
		}
	}
tools/perf/builtin-script.c:3106:			continue;
		}
	}
tools/perf/util/parse-events.c:505:				continue;
		}
	}
tools/perf/util/jitdump.c:708:			continue;
		}
	}
tools/perf/ui/browsers/hists.c:3543:			continue;
		}
	}
tools/testing/radix-tree/regression3.c:54:			continue;
		}
	}
tools/testing/radix-tree/regression3.c:67:			continue;
		}
	}
tools/testing/selftests/net/mptcp/mptcp_connect.c:371:			continue;
		}
	}
tools/testing/selftests/net/timestamping.c:546:			continue;
		}
	}
tools/testing/selftests/powerpc/nx-gzip/gzip_vas.c:252:			continue;
		}
	}
tools/power/cpupower/lib/cpupower.c:177:			continue;
		}
	}
tools/lib/bpf/libbpf.c:7417:			continue;
		}
	}
tools/lib/bpf/btf.c:928:			continue;
		}
	}
tools/lib/bpf/linker.c:835:			continue;
		}
	}


