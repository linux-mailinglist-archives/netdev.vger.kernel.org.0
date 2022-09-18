Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9B55BBBF4
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 06:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiIREzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 00:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiIREzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 00:55:09 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FFA167C6;
        Sat, 17 Sep 2022 21:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663476906; x=1695012906;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=epSNHhdQxzAXTtOVkg0lQms6n58dl1u6MupG0x4QYh8=;
  b=GR5apPchRcH3LVZ5otBuHHrCXTvyxu3XqDCm44EwKDSKsMWdQI0ktqb8
   x83m4ti4GQqFx5in2ogfhYEIa1p/AS43FZbLmBl9pBYye0tBKn1jxriR+
   h4HSQtVa+WCMSwpvj88li7JFBbEMTkYB3RyhcLxkinpH+qTeYrqQaV/97
   Bh5cj66evOUnVoSAWHZ1ppHmnocwbfEslokfSwgTvFmsxJBPvhyuV013l
   js+x99okT0rtXgOaEXOqpineyKLVUnQifyyJ5A6hPFBG/IF8kDi1OsgCC
   MePDm7K0DuyJCI1+OXMKyfZ4FNSnUaxvue2ygAIOwmAvTIUNcWTLZA7/a
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10473"; a="297931506"
X-IronPort-AV: E=Sophos;i="5.93,323,1654585200"; 
   d="scan'208";a="297931506"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2022 21:55:06 -0700
X-IronPort-AV: E=Sophos;i="5.93,323,1654585200"; 
   d="scan'208";a="793503255"
Received: from naamamex-mobl.ger.corp.intel.com (HELO [10.13.13.50]) ([10.13.13.50])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2022 21:54:35 -0700
Message-ID: <4d81077c-6dcd-a442-201a-113b087f3ca9@linux.intel.com>
Date:   Sun, 18 Sep 2022 07:54:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [Intel-wired-lan] [PATCH v2 3/3] net: ethernet: move from strlcpy
 with unused retval to strscpy
Content-Language: en-US
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-kernel@vger.kernel.org
Cc:     Kevin Brace <kevinbrace@bracecomputerlab.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Leon Romanovsky <leonro@nvidia.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Andy Gospodarek <andy@greyhouse.net>,
        Manish Chopra <manishc@marvell.com>,
        Samuel Holland <samuel@sholland.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Jose Abreu <joabreu@synopsys.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Chris Lee <christopher.lee@cspi.com>,
        Nick Child <nnac123@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>,
        Shay Agroskin <shayagr@amazon.com>, linux-omap@vger.kernel.org,
        Petr Machata <petrm@nvidia.com>,
        Geoff Levand <geoff@infradead.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Douglas Miller <dougmill@linux.ibm.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Ion Badulescu <ionut@badula.org>,
        Rasesh Mody <rmody@marvell.com>, Jon Mason <jdmason@kudzu.us>,
        Christian Benvenuti <benve@cisco.com>,
        Samuel Chessman <chessman@tux.org>,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Chris Snook <chris.snook@gmail.com>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Daniele Venzano <venza@brownhat.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Leon Romanovsky <leon@kernel.org>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Sean Wang <sean.wang@mediatek.com>,
        linuxppc-dev@lists.ozlabs.org,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Doug Berger <opendmb@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        linux-arm-kernel@lists.infradead.org,
        Mirko Lindner <mlindner@marvell.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        David Arinzon <darinzon@amazon.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Andreas Larsson <andreas@gaisler.com>,
        oss-drivers@corigine.com, Subbaraya Sundeep <sbhatta@marvell.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Noam Dagan <ndagan@amazon.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org, Guo-Fu Tseng <cooldavid@cooldavid.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Simon Horman <simon.horman@corigine.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Shahed Shaikh <shshaikh@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Byungho An <bh74.an@samsung.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Don Fry <pcnet32@frontier.com>,
        John Crispin <john@phrozen.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        Salil Mehta <salil.mehta@huawei.com>,
        GR-Linux-NIC-Dev@marvell.com, linux-parisc@vger.kernel.org,
        linux-sunxi@lists.linux.dev, Edward Cree <ecree.xilinx@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Mark Einon <mark.einon@gmail.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        UNGLinuxDriver@microchip.com, linux-acenic@sunsite.dk,
        Rahul Verma <rahulv@marvell.com>,
        Russell King <linux@armlinux.org.uk>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        intel-wired-lan@lists.osuosl.org, Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <klassert@kernel.org>,
        Sunil Goutham <sgoutham@marvell.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jes Sorensen <jes@trained-monkey.org>, nic_swsd@realtek.com,
        Ariel Elior <aelior@marvell.com>,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Marcin Wojtas <mw@semihalf.com>, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        hariprasad <hkelam@marvell.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Felix Fietkau <nbd@nbd.name>
References: <20220830201457.7984-1-wsa+renesas@sang-engineering.com>
 <20220830201457.7984-3-wsa+renesas@sang-engineering.com>
From:   "naamax.meir" <naamax.meir@linux.intel.com>
In-Reply-To: <20220830201457.7984-3-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/2022 23:14, Wolfram Sang wrote:
> Follow the advice of the below link and prefer 'strscpy' in this
> subsystem. Conversion is 1:1 because the return value is not used.
> Generated by a coccinelle script.
> 
> Link: https://lore.kernel.org/r/CAHk-=wgfRnXz0W3D37d01q3JFkr_i_uTL=V6A6G1oUZcprmknw@mail.gmail.com/
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com> # For drivers/net/ethernet/mellanox/mlxsw
> Acked-by: Geoff Levand <geoff@infradead.org> # For ps3_gelic_net and spider_net_ethtool
> Acked-by: Tom Lendacky <thomas.lendacky@amd.com> # For drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
> Acked-by: Marcin Wojtas <mw@semihalf.com> # For drivers/net/ethernet/marvell/mvpp2
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com> # For drivers/net/ethernet/mellanox/mlx{4|5}
> Reviewed-by: Shay Agroskin <shayagr@amazon.com> # For drivers/net/ethernet/amazon/ena
> Acked-by: Krzysztof Hałasa <khalasa@piap.pl> # For IXP4xx Ethernet
> ---
> 
> Changes since v1:
> * split into smaller patches
> * added given tags
> 
>   drivers/net/ethernet/3com/3c509.c                |  2 +-
>   drivers/net/ethernet/3com/3c515.c                |  2 +-
>   drivers/net/ethernet/3com/3c589_cs.c             |  2 +-
>   drivers/net/ethernet/3com/3c59x.c                |  6 +++---
>   drivers/net/ethernet/3com/typhoon.c              |  8 ++++----
>   drivers/net/ethernet/8390/ax88796.c              |  6 +++---
>   drivers/net/ethernet/8390/etherh.c               |  6 +++---
>   drivers/net/ethernet/adaptec/starfire.c          |  4 ++--
>   drivers/net/ethernet/aeroflex/greth.c            |  4 ++--
>   drivers/net/ethernet/agere/et131x.c              |  4 ++--
>   drivers/net/ethernet/alacritech/slicoss.c        |  4 ++--
>   drivers/net/ethernet/allwinner/sun4i-emac.c      |  4 ++--
>   drivers/net/ethernet/alteon/acenic.c             |  4 ++--
>   drivers/net/ethernet/amazon/ena/ena_ethtool.c    |  4 ++--
>   drivers/net/ethernet/amazon/ena/ena_netdev.c     |  2 +-
>   drivers/net/ethernet/amd/amd8111e.c              |  4 ++--
>   drivers/net/ethernet/amd/au1000_eth.c            |  2 +-
>   drivers/net/ethernet/amd/nmclan_cs.c             |  2 +-
>   drivers/net/ethernet/amd/pcnet32.c               |  4 ++--
>   drivers/net/ethernet/amd/sunlance.c              |  2 +-
>   drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c     |  4 ++--
>   .../net/ethernet/aquantia/atlantic/aq_ethtool.c  |  2 +-
>   drivers/net/ethernet/arc/emac_main.c             |  2 +-
>   drivers/net/ethernet/atheros/ag71xx.c            |  4 ++--
>   .../net/ethernet/atheros/atl1c/atl1c_ethtool.c   |  4 ++--
>   .../net/ethernet/atheros/atl1e/atl1e_ethtool.c   |  6 +++---
>   drivers/net/ethernet/atheros/atlx/atl1.c         |  4 ++--
>   drivers/net/ethernet/atheros/atlx/atl2.c         |  6 +++---
>   drivers/net/ethernet/broadcom/b44.c              |  6 +++---
>   drivers/net/ethernet/broadcom/bcm63xx_enet.c     |  4 ++--
>   drivers/net/ethernet/broadcom/bcmsysport.c       |  4 ++--
>   drivers/net/ethernet/broadcom/bgmac.c            |  6 +++---
>   drivers/net/ethernet/broadcom/bnx2.c             |  6 +++---
>   drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c  |  2 +-
>   .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c  |  6 +++---
>   drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |  2 +-
>   .../net/ethernet/broadcom/bnx2x/bnx2x_sriov.h    |  2 +-
>   drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c |  2 +-
>   .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c    |  8 ++++----
>   drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c    |  2 +-
>   drivers/net/ethernet/broadcom/genet/bcmgenet.c   |  2 +-
>   drivers/net/ethernet/broadcom/tg3.c              |  6 +++---
>   drivers/net/ethernet/brocade/bna/bnad_ethtool.c  |  6 +++---
>   drivers/net/ethernet/cavium/octeon/octeon_mgmt.c |  2 +-
>   .../net/ethernet/cavium/thunder/nicvf_ethtool.c  |  4 ++--
>   drivers/net/ethernet/chelsio/cxgb/cxgb2.c        |  4 ++--
>   drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c  |  4 ++--
>   .../net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c   |  4 ++--
>   drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c  |  4 ++--
>   .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c  |  4 ++--
>   .../chelsio/inline_crypto/chtls/chtls_main.c     |  2 +-
>   drivers/net/ethernet/cirrus/ep93xx_eth.c         |  2 +-
>   drivers/net/ethernet/cisco/enic/enic_ethtool.c   |  6 +++---
>   drivers/net/ethernet/davicom/dm9000.c            |  4 ++--
>   drivers/net/ethernet/dec/tulip/de2104x.c         |  4 ++--
>   drivers/net/ethernet/dec/tulip/dmfe.c            |  4 ++--
>   drivers/net/ethernet/dec/tulip/tulip_core.c      |  4 ++--
>   drivers/net/ethernet/dec/tulip/uli526x.c         |  4 ++--
>   drivers/net/ethernet/dec/tulip/winbond-840.c     |  4 ++--
>   drivers/net/ethernet/dlink/dl2k.c                |  4 ++--
>   drivers/net/ethernet/dlink/sundance.c            |  4 ++--
>   drivers/net/ethernet/dnet.c                      |  4 ++--
>   drivers/net/ethernet/emulex/benet/be_cmds.c      | 12 ++++++------
>   drivers/net/ethernet/emulex/benet/be_ethtool.c   |  6 +++---
>   drivers/net/ethernet/faraday/ftgmac100.c         |  4 ++--
>   drivers/net/ethernet/faraday/ftmac100.c          |  4 ++--
>   drivers/net/ethernet/fealnx.c                    |  4 ++--
>   .../net/ethernet/freescale/dpaa/dpaa_ethtool.c   |  4 ++--
>   drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c |  2 +-
>   .../net/ethernet/freescale/enetc/enetc_ethtool.c |  4 ++--
>   drivers/net/ethernet/freescale/fec_main.c        |  8 ++++----
>   drivers/net/ethernet/freescale/fec_ptp.c         |  2 +-
>   .../ethernet/freescale/fs_enet/fs_enet-main.c    |  2 +-
>   drivers/net/ethernet/freescale/gianfar_ethtool.c |  2 +-
>   .../net/ethernet/freescale/ucc_geth_ethtool.c    |  4 ++--
>   drivers/net/ethernet/fujitsu/fmvj18x_cs.c        |  4 ++--
>   drivers/net/ethernet/hisilicon/hip04_eth.c       |  4 ++--
>   drivers/net/ethernet/ibm/ehea/ehea_ethtool.c     |  4 ++--
>   drivers/net/ethernet/ibm/emac/core.c             |  4 ++--
>   drivers/net/ethernet/ibm/ibmveth.c               |  4 ++--
>   drivers/net/ethernet/intel/e100.c                |  4 ++--
>   drivers/net/ethernet/intel/e1000/e1000_ethtool.c |  4 ++--
>   drivers/net/ethernet/intel/e1000e/ethtool.c      |  4 ++--
>   drivers/net/ethernet/intel/e1000e/netdev.c       |  6 +++---
>   drivers/net/ethernet/intel/i40e/i40e_ethtool.c   |  6 +++---
>   drivers/net/ethernet/intel/i40e/i40e_main.c      | 16 ++++++++--------
>   drivers/net/ethernet/intel/i40e/i40e_ptp.c       |  2 +-
>   drivers/net/ethernet/intel/iavf/iavf_ethtool.c   |  6 +++---
>   drivers/net/ethernet/intel/igb/igb_ethtool.c     |  6 +++---
>   drivers/net/ethernet/intel/igb/igb_main.c        |  2 +-
>   drivers/net/ethernet/intel/igbvf/ethtool.c       |  4 ++--
>   drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c   |  4 ++--
>   drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c |  6 +++---
>   drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c    |  2 +-
>   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c    |  4 ++--
>   drivers/net/ethernet/intel/ixgbevf/ethtool.c     |  4 ++--
>   drivers/net/ethernet/jme.c                       |  6 +++---
>   drivers/net/ethernet/korina.c                    |  6 +++---
>   drivers/net/ethernet/marvell/mv643xx_eth.c       |  8 ++++----
>   drivers/net/ethernet/marvell/mvneta.c            |  6 +++---
>   drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c  |  6 +++---
>   .../marvell/octeontx2/nic/otx2_ethtool.c         |  8 ++++----
>   .../ethernet/marvell/prestera/prestera_ethtool.c |  4 ++--
>   drivers/net/ethernet/marvell/pxa168_eth.c        |  8 ++++----
>   drivers/net/ethernet/marvell/skge.c              |  6 +++---
>   drivers/net/ethernet/marvell/sky2.c              |  6 +++---
>   drivers/net/ethernet/mediatek/mtk_eth_soc.c      |  4 ++--
>   drivers/net/ethernet/mediatek/mtk_star_emac.c    |  2 +-
>   drivers/net/ethernet/mellanox/mlx4/en_ethtool.c  |  6 +++---
>   drivers/net/ethernet/mellanox/mlx4/fw.c          |  2 +-
>   .../net/ethernet/mellanox/mlx5/core/en_ethtool.c |  4 ++--
>   drivers/net/ethernet/mellanox/mlx5/core/en_rep.c |  2 +-
>   .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c  |  2 +-
>   drivers/net/ethernet/mellanox/mlxsw/core.c       |  2 +-
>   drivers/net/ethernet/mellanox/mlxsw/minimal.c    |  4 ++--
>   .../ethernet/mellanox/mlxsw/spectrum_ethtool.c   |  6 +++---
>   drivers/net/ethernet/micrel/ks8851_common.c      |  6 +++---
>   drivers/net/ethernet/micrel/ksz884x.c            |  6 +++---
>   drivers/net/ethernet/microchip/enc28j60.c        |  6 +++---
>   drivers/net/ethernet/microchip/encx24j600.c      |  6 +++---
>   drivers/net/ethernet/microchip/lan743x_ethtool.c |  4 ++--
>   drivers/net/ethernet/myricom/myri10ge/myri10ge.c |  8 ++++----
>   drivers/net/ethernet/natsemi/natsemi.c           |  6 +++---
>   drivers/net/ethernet/natsemi/ns83820.c           |  6 +++---
>   drivers/net/ethernet/neterion/s2io.c             |  6 +++---
>   .../net/ethernet/netronome/nfp/nfp_net_ethtool.c |  6 +++---
>   drivers/net/ethernet/ni/nixge.c                  |  4 ++--
>   drivers/net/ethernet/nvidia/forcedeth.c          |  6 +++---
>   drivers/net/ethernet/nxp/lpc_eth.c               |  6 +++---
>   .../ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c  |  6 +++---
>   drivers/net/ethernet/packetengines/hamachi.c     |  6 +++---
>   drivers/net/ethernet/packetengines/yellowfin.c   |  6 +++---
>   .../ethernet/qlogic/netxen/netxen_nic_ethtool.c  |  6 +++---
>   drivers/net/ethernet/qlogic/qed/qed_int.c        |  2 +-
>   drivers/net/ethernet/qlogic/qede/qede_ethtool.c  |  4 ++--
>   drivers/net/ethernet/qlogic/qede/qede_main.c     |  2 +-
>   drivers/net/ethernet/qlogic/qla3xxx.c            |  6 +++---
>   .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c  |  6 +++---
>   drivers/net/ethernet/qualcomm/qca_debug.c        |  8 ++++----
>   drivers/net/ethernet/rdc/r6040.c                 |  6 +++---
>   drivers/net/ethernet/realtek/8139cp.c            |  6 +++---
>   drivers/net/ethernet/realtek/8139too.c           |  6 +++---
>   drivers/net/ethernet/realtek/r8169_main.c        |  6 +++---
>   drivers/net/ethernet/rocker/rocker_main.c        |  4 ++--
>   .../net/ethernet/samsung/sxgbe/sxgbe_ethtool.c   |  4 ++--
>   drivers/net/ethernet/sfc/efx.c                   |  2 +-
>   drivers/net/ethernet/sfc/efx_common.c            |  2 +-
>   drivers/net/ethernet/sfc/ethtool_common.c        |  6 +++---
>   drivers/net/ethernet/sfc/falcon/efx.c            |  4 ++--
>   drivers/net/ethernet/sfc/falcon/ethtool.c        |  8 ++++----
>   drivers/net/ethernet/sfc/falcon/falcon.c         |  2 +-
>   drivers/net/ethernet/sfc/falcon/nic.c            |  2 +-
>   drivers/net/ethernet/sfc/mcdi_mon.c              |  2 +-
>   drivers/net/ethernet/sfc/nic.c                   |  2 +-
>   drivers/net/ethernet/sfc/siena/efx.c             |  2 +-
>   drivers/net/ethernet/sfc/siena/efx_common.c      |  2 +-
>   drivers/net/ethernet/sfc/siena/ethtool_common.c  |  6 +++---
>   drivers/net/ethernet/sfc/siena/mcdi_mon.c        |  2 +-
>   drivers/net/ethernet/sfc/siena/nic.c             |  2 +-
>   drivers/net/ethernet/sgi/ioc3-eth.c              |  6 +++---
>   drivers/net/ethernet/sis/sis190.c                |  6 +++---
>   drivers/net/ethernet/sis/sis900.c                |  6 +++---
>   drivers/net/ethernet/smsc/epic100.c              |  6 +++---
>   drivers/net/ethernet/smsc/smc911x.c              |  6 +++---
>   drivers/net/ethernet/smsc/smc91c92_cs.c          |  4 ++--
>   drivers/net/ethernet/smsc/smc91x.c               |  6 +++---
>   drivers/net/ethernet/smsc/smsc911x.c             |  6 +++---
>   drivers/net/ethernet/smsc/smsc9420.c             |  6 +++---
>   drivers/net/ethernet/socionext/netsec.c          |  4 ++--
>   drivers/net/ethernet/socionext/sni_ave.c         |  4 ++--
>   .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c |  8 ++++----
>   drivers/net/ethernet/sun/cassini.c               |  6 +++---
>   drivers/net/ethernet/sun/ldmvsw.c                |  4 ++--
>   drivers/net/ethernet/sun/niu.c                   |  6 +++---
>   drivers/net/ethernet/sun/sunbmac.c               |  4 ++--
>   drivers/net/ethernet/sun/sungem.c                |  6 +++---
>   drivers/net/ethernet/sun/sunhme.c                |  6 +++---
>   drivers/net/ethernet/sun/sunqe.c                 |  4 ++--
>   drivers/net/ethernet/sun/sunvnet.c               |  4 ++--
>   .../net/ethernet/synopsys/dwc-xlgmac-common.c    |  4 ++--
>   .../net/ethernet/synopsys/dwc-xlgmac-ethtool.c   |  6 +++---
>   drivers/net/ethernet/tehuti/tehuti.c             |  8 ++++----
>   drivers/net/ethernet/ti/am65-cpsw-ethtool.c      |  4 ++--
>   drivers/net/ethernet/ti/cpmac.c                  |  4 ++--
>   drivers/net/ethernet/ti/cpsw.c                   |  6 +++---
>   drivers/net/ethernet/ti/cpsw_new.c               |  6 +++---
>   drivers/net/ethernet/ti/davinci_emac.c           |  4 ++--
>   drivers/net/ethernet/ti/tlan.c                   |  6 +++---
>   drivers/net/ethernet/toshiba/ps3_gelic_net.c     |  4 ++--
>   .../net/ethernet/toshiba/spider_net_ethtool.c    |  8 ++++----
>   drivers/net/ethernet/toshiba/tc35815.c           |  6 +++---
>   drivers/net/ethernet/via/via-rhine.c             |  4 ++--
>   drivers/net/ethernet/via/via-velocity.c          |  8 ++++----
>   drivers/net/ethernet/wiznet/w5100.c              |  6 +++---
>   drivers/net/ethernet/wiznet/w5300.c              |  6 +++---
>   .../net/ethernet/xilinx/xilinx_axienet_main.c    |  4 ++--
>   drivers/net/ethernet/xilinx/xilinx_emaclite.c    |  2 +-
>   drivers/net/ethernet/xircom/xirc2ps_cs.c         |  2 +-
>   drivers/net/ethernet/xscale/ixp4xx_eth.c         |  4 ++--
>   199 files changed, 457 insertions(+), 457 deletions(-)
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
