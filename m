Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233DB6B52AB
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 22:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjCJVUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 16:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbjCJVT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 16:19:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C7E126F27
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 13:19:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B956B822AD
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 21:19:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E510FC433D2;
        Fri, 10 Mar 2023 21:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678483192;
        bh=2Wb7cnmDG2w5cDD3J6QqrQaL6VG+vXvdwPBt25Rx7LM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=U/7nizjCbxeo7TduE8YQ5ns3a3L/gAchlcLM97zigX/BuQhXpAL9QHsjcgkBYAmlt
         c4lx94OfAaip20nQ93U8lLFaMcXISMw5Rd/tc/dJafqC3nzoYhtrhMX6bKX+y14ng0
         sQHwspFj8OJWkluMdtBrL4OfQMiwEnOa83dmfkpCtvX94XVKg1hC60b8Mw+Yh5Adz5
         76BWUPJlQcWTe6yi12PvIJoHKcLMDUp6aNsXbCNfuL5py+IATNbwvZ53KY871eK+bo
         iC1htP96ueNAEjjFMgXUh2eCRfPbZY1uzCdO9Fp3V/Uyj+S9n6CICsvQ0i84BfuwSX
         N4Nq9Y5prHgkg==
Date:   Fri, 10 Mar 2023 15:19:50 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC 6/6] r8169: remove ASPM restrictions now that ASPM is
 disabled during NAPI poll
Message-ID: <20230310211950.GA1280275@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d61ba5a-9a2c-28c3-4a1b-a81a3f34af3d@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 25, 2023 at 10:47:32PM +0100, Heiner Kallweit wrote:
> Now that  ASPM is disabled during NAPI poll, we can remove all ASPM
> restrictions. This allows for higher power savings if the network
> isn't fully loaded.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 27 +----------------------
>  1 file changed, 1 insertion(+), 26 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 2897b9bf2..6563e4c6a 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -620,7 +620,6 @@ struct rtl8169_private {
>  	int cfg9346_usage_count;
>  
>  	unsigned supports_gmii:1;
> -	unsigned aspm_manageable:1;
>  	dma_addr_t counters_phys_addr;
>  	struct rtl8169_counters *counters;
>  	struct rtl8169_tc_offsets tc_offset;
> @@ -2744,8 +2743,7 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
>  	if (tp->mac_version < RTL_GIGA_MAC_VER_32)
>  		return;
>  
> -	/* Don't enable ASPM in the chip if OS can't control ASPM */
> -	if (enable && tp->aspm_manageable) {
> +	if (enable) {
>  		rtl_mod_config5(tp, 0, ASPM_en);
>  		rtl_mod_config2(tp, 0, ClkReqEn);
>  
> @@ -5221,16 +5219,6 @@ static void rtl_init_mac_address(struct rtl8169_private *tp)
>  	rtl_rar_set(tp, mac_addr);
>  }
>  
> -/* register is set if system vendor successfully tested ASPM 1.2 */
> -static bool rtl_aspm_is_safe(struct rtl8169_private *tp)
> -{
> -	if (tp->mac_version >= RTL_GIGA_MAC_VER_61 &&
> -	    r8168_mac_ocp_read(tp, 0xc0b2) & 0xf)
> -		return true;
> -
> -	return false;
> -}
> -
>  static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  {
>  	struct rtl8169_private *tp;
> @@ -5302,19 +5290,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  
>  	tp->mac_version = chipset;
>  
> -	/* Disable ASPM L1 as that cause random device stop working
> -	 * problems as well as full system hangs for some PCIe devices users.
> -	 * Chips from RTL8168h partially have issues with L1.2, but seem
> -	 * to work fine with L1 and L1.1.
> -	 */
> -	if (rtl_aspm_is_safe(tp))
> -		rc = 0;
> -	else if (tp->mac_version >= RTL_GIGA_MAC_VER_46)
> -		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1_2);
> -	else
> -		rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L1);
> -	tp->aspm_manageable = !rc;

This is beautiful.  But since this series still enables/disables ASPM
using the chip-specific knobs, I have to ask whether this is all safe
with respect to simultaneous arbitrary ASPM enable/disable via the
sysfs knobs.  For example, it should be safe to run these loops
indefinitely while the NIC is operating and doing NAPI polls:

  DEV=/sys/bus/pci/devices/...
  while /bin/true; do
    echo 1 > $DEV/link/l1_2_aspm
    echo 0 > $DEV/link/l1_2_aspm
  done
  while /bin/true; do
    echo 1 > $DEV/link/l1_1_aspm
    echo 0 > $DEV/link/l1_1_aspm
  done
  while /bin/true; do
    echo 1 > $DEV/link/l1_aspm
    echo 0 > $DEV/link/l1_aspm
  done

Bjorn
