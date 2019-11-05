Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A84D5F042E
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 18:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390380AbfKERfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 12:35:53 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40485 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388969AbfKERfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 12:35:52 -0500
Received: by mail-wr1-f65.google.com with SMTP id i10so1738331wrs.7
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 09:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=ajzuj/muM4gBXlCM6s54GbeReO4pA/up1MpKbxzdkR4=;
        b=k/15RJkWeyf/PuaTImk3nC8SPZuN34685kfYrbTV6+4X+UxIfyYE5PoGJo2JbiJLnb
         VU6Z2dpJyoNsYaD3YWUEdxxa1to15BdZx0w5yqjK9z6RNtaaMfoXC8JyV8DfdKt5So5H
         aVY3fUzTUQf5B40ghQh9G0dDlXxVjvabAd70bw0MApLug91FKoSYzQzlOA+rkwfZbytR
         rAmGQX9D6jun/OKEafdxemoPYKE4chfzzAtJDstuvohE0ojLzlOq6ipj+Rybrj+OWhBQ
         cvAZF8mEUUF6d+C1wowx6kWC2YgrCIohz2/FjwX17r5C1nUbSEwm+rWdUFJTOxc4YK/5
         3Uqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=ajzuj/muM4gBXlCM6s54GbeReO4pA/up1MpKbxzdkR4=;
        b=i2FLFr/jA3TB9q0t9o7gv5H2/A8pEzHrPcMTM6WYAzU2VEDkK9lTCFqSwO3Svq4OQI
         iBIDpmDV/Lw6hEYHXq2soZDjHPw18PFw8t/MOOtTfD8+oV+b7qnlq+whU/e+hDtUadU3
         JV0zbp6M+ZEfJ6QA4aK/HGeJlDlcTQmoB7uSAYPFyuQ+2Z+64h8/FgZqRbSqycSmdZp6
         Rkper3FPK+DYmbp/vLUK8EDXGI/fQwI8caZeFV3M5LUoMDz2rsvd9QHoxK3gODEPSiUr
         Gzlml/MeF0Uea4McsdYVWKv7IAdqnb6fluQxDXnVBQRlihiBoq5s0+6GixQrsgJtGyvW
         FyBQ==
X-Gm-Message-State: APjAAAW47M+HOtp/CANdZ0Bi/uEpYz9Q80+g0Kgllro3S/c521KNhaKB
        ZyvfsK3kJRK66coUYLdbPTEjmI8=
X-Google-Smtp-Source: APXvYqy0h0X3wILsFWfhqi5ZD/VcX6hWk6Pn0aGNMakswwezSTsoYqiosgZhyx7KAvOEOwULD1cjaw==
X-Received: by 2002:adf:eb48:: with SMTP id u8mr24647192wrn.225.1572975347199;
        Tue, 05 Nov 2019 09:35:47 -0800 (PST)
Received: from avx2 ([46.53.250.94])
        by smtp.gmail.com with ESMTPSA id z17sm19067053wrh.57.2019.11.05.09.35.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 09:35:46 -0800 (PST)
Date:   Tue, 5 Nov 2019 20:35:43 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH DO NOT APPLY] mac_t: Ethernet MAC type
Message-ID: <20191105173543.GA24142@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Will something like this be accepted?

Some of u8[6] arrays may not be 2-byte aligned still!

The plan is
* create "mac_t" type -- safe alias for u8[ETH_ALEN]

* convert all uses in structures first, passing "mac->o" or
  "mac.o" to functions,

* convert functions accepting MAC pointers,




--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -770,7 +770,7 @@ static int ns_init_card(int i, struct pci_dev *pcidev)
 		return error;
 	}
 
-	if (mac[i] == NULL || !mac_pton(mac[i], card->atmdev->esi)) {
+	if (mac[i] == NULL || !mac_pton(mac[i], (mac_t *)card->atmdev->esi)) {
 		nicstar_read_eprom(card->membase, NICSTAR_EPROM_MAC_ADDR_OFFSET,
 				   card->atmdev->esi, 6);
 		if (ether_addr_equal(card->atmdev->esi, "\x00\x00\x00\x00\x00\x00")) {
--- a/drivers/firmware/broadcom/bcm47xx_sprom.c
+++ b/drivers/firmware/broadcom/bcm47xx_sprom.c
@@ -138,7 +138,7 @@ static void nvram_read_leddc(const char *prefix, const char *name,
 }
 
 static void nvram_read_macaddr(const char *prefix, const char *name,
-			       u8 val[6], bool fallback)
+			       mac_t *val, bool fallback)
 {
 	char buf[100];
 	int err;
@@ -511,24 +511,24 @@ static void bcm47xx_fill_sprom_ethernet(struct ssb_sprom *sprom,
 {
 	bool fb = fallback;
 
-	nvram_read_macaddr(prefix, "et0macaddr", sprom->et0mac, fallback);
+	nvram_read_macaddr(prefix, "et0macaddr", (mac_t *)sprom->et0mac, fallback);
 	nvram_read_u8(prefix, NULL, "et0mdcport", &sprom->et0mdcport, 0,
 		      fallback);
 	nvram_read_u8(prefix, NULL, "et0phyaddr", &sprom->et0phyaddr, 0,
 		      fallback);
 
-	nvram_read_macaddr(prefix, "et1macaddr", sprom->et1mac, fallback);
+	nvram_read_macaddr(prefix, "et1macaddr", (mac_t *)sprom->et1mac, fallback);
 	nvram_read_u8(prefix, NULL, "et1mdcport", &sprom->et1mdcport, 0,
 		      fallback);
 	nvram_read_u8(prefix, NULL, "et1phyaddr", &sprom->et1phyaddr, 0,
 		      fallback);
 
-	nvram_read_macaddr(prefix, "et2macaddr", sprom->et2mac, fb);
+	nvram_read_macaddr(prefix, "et2macaddr", (mac_t *)sprom->et2mac, fb);
 	nvram_read_u8(prefix, NULL, "et2mdcport", &sprom->et2mdcport, 0, fb);
 	nvram_read_u8(prefix, NULL, "et2phyaddr", &sprom->et2phyaddr, 0, fb);
 
-	nvram_read_macaddr(prefix, "macaddr", sprom->il0mac, fallback);
-	nvram_read_macaddr(prefix, "il0macaddr", sprom->il0mac, fallback);
+	nvram_read_macaddr(prefix, "macaddr", (mac_t *)sprom->il0mac, fallback);
+	nvram_read_macaddr(prefix, "il0macaddr", (mac_t *)sprom->il0mac, fallback);
 
 	/* The address prefix 00:90:4C is used by Broadcom in their initial
 	 * configuration. When a mac address with the prefix 00:90:4C is used
@@ -537,14 +537,14 @@ static void bcm47xx_fill_sprom_ethernet(struct ssb_sprom *sprom,
 	 * based on the base address.
 	 */
 	if (!bcm47xx_is_valid_mac(sprom->il0mac)) {
-		u8 mac[6];
+		mac_t mac;
 
-		nvram_read_macaddr(NULL, "et0macaddr", mac, false);
-		if (bcm47xx_is_valid_mac(mac)) {
-			int err = bcm47xx_increase_mac_addr(mac, mac_addr_used);
+		nvram_read_macaddr(NULL, "et0macaddr", &mac, false);
+		if (bcm47xx_is_valid_mac(mac.o)) {
+			int err = bcm47xx_increase_mac_addr(mac.o, mac_addr_used);
 
 			if (!err) {
-				ether_addr_copy(sprom->il0mac, mac);
+				ether_addr_copy(sprom->il0mac, mac.o);
 				mac_addr_used++;
 			}
 		}
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -13,6 +13,7 @@
 #include <linux/io.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
+#include <linux/etherdevice.h>
 #include <linux/if_ether.h>
 #include <linux/ctype.h>
 #include <linux/dmi.h>
@@ -624,19 +625,19 @@ static ssize_t show_pch_mac(struct device *dev, struct device_attribute *attr,
 static ssize_t store_pch_mac(struct device *dev, struct device_attribute *attr,
 			     const char *buf, size_t count)
 {
-	u8 mac[ETH_ALEN];
+	mac_t mac;
 	ssize_t rom_size;
 	struct pch_phub_reg *chip = dev_get_drvdata(dev);
 	int ret;
 
-	if (!mac_pton(buf, mac))
+	if (!mac_pton(buf, &mac))
 		return -EINVAL;
 
 	chip->pch_phub_extrom_base_address = pci_map_rom(chip->pdev, &rom_size);
 	if (!chip->pch_phub_extrom_base_address)
 		return -ENOMEM;
 
-	ret = pch_phub_write_gbe_mac_addr(chip, mac);
+	ret = pch_phub_write_gbe_mac_addr(chip, mac.o);
 	pci_unmap_rom(chip->pdev, chip->pch_phub_extrom_base_address);
 	if (ret)
 		return ret;
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1439,22 +1439,22 @@ static int bond_option_ad_actor_sys_prio_set(struct bonding *bond,
 static int bond_option_ad_actor_system_set(struct bonding *bond,
 					   const struct bond_opt_value *newval)
 {
-	u8 macaddr[ETH_ALEN];
-	u8 *mac;
+	mac_t macaddr;
+	mac_t *mac;
 
 	if (newval->string) {
-		if (!mac_pton(newval->string, macaddr))
+		if (!mac_pton(newval->string, &macaddr))
 			goto err;
-		mac = macaddr;
+		mac = &macaddr;
 	} else {
-		mac = (u8 *)&newval->value;
+		mac = (mac_t *)&newval->value;
 	}
 
-	if (!is_valid_ether_addr(mac))
+	if (!is_valid_ether_addr(mac->o))
 		goto err;
 
 	netdev_dbg(bond->dev, "Setting ad_actor_system to %pM\n", mac);
-	ether_addr_copy(bond->params.ad_actor_system, mac);
+	ether_addr_copy(bond->params.ad_actor_system, mac->o);
 	bond_3ad_update_ad_actor_settings(bond);
 
 	return 0;
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -180,7 +180,7 @@ static struct netconsole_target *alloc_param_target(char *target_config)
 	strlcpy(nt->np.dev_name, "eth0", IFNAMSIZ);
 	nt->np.local_port = 6665;
 	nt->np.remote_port = 6666;
-	eth_broadcast_addr(nt->np.remote_mac);
+	eth_broadcast_addr(nt->np.remote_mac.o);
 
 	if (*target_config == '+') {
 		nt->extended = true;
@@ -298,7 +298,7 @@ static ssize_t local_mac_show(struct config_item *item, char *buf)
 
 static ssize_t remote_mac_show(struct config_item *item, char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%pM\n", to_target(item)->np.remote_mac);
+	return snprintf(buf, PAGE_SIZE, "%pM\n", &to_target(item)->np.remote_mac);
 }
 
 /*
@@ -546,7 +546,7 @@ static ssize_t remote_mac_store(struct config_item *item, const char *buf,
 		size_t count)
 {
 	struct netconsole_target *nt = to_target(item);
-	u8 remote_mac[ETH_ALEN];
+	mac_t remote_mac;
 
 	mutex_lock(&dynamic_netconsole_mutex);
 	if (nt->enabled) {
@@ -555,11 +555,11 @@ static ssize_t remote_mac_store(struct config_item *item, const char *buf,
 		goto out_unlock;
 	}
 
-	if (!mac_pton(buf, remote_mac))
+	if (!mac_pton(buf, &remote_mac))
 		goto out_unlock;
 	if (buf[3 * ETH_ALEN - 1] && buf[3 * ETH_ALEN - 1] != '\n')
 		goto out_unlock;
-	memcpy(nt->np.remote_mac, remote_mac, ETH_ALEN);
+	nt->np.remote_mac = remote_mac;
 
 	mutex_unlock(&dynamic_netconsole_mutex);
 	return strnlen(buf, count);
@@ -632,7 +632,7 @@ static struct config_item *make_netconsole_target(struct config_group *group,
 	strlcpy(nt->np.dev_name, "eth0", IFNAMSIZ);
 	nt->np.local_port = 6665;
 	nt->np.remote_port = 6666;
-	eth_broadcast_addr(nt->np.remote_mac);
+	eth_broadcast_addr(nt->np.remote_mac.o);
 
 	/* Initialize the config_item member */
 	config_item_init_type_name(&nt->item, name, &netconsole_target_type);
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -1233,17 +1233,17 @@ static ssize_t ath6kl_force_roam_write(struct file *file,
 	int ret;
 	char buf[20];
 	size_t len;
-	u8 bssid[ETH_ALEN];
+	mac_t bssid;
 
 	len = min(count, sizeof(buf) - 1);
 	if (copy_from_user(buf, user_buf, len))
 		return -EFAULT;
 	buf[len] = '\0';
 
-	if (!mac_pton(buf, bssid))
+	if (!mac_pton(buf, &bssid))
 		return -EINVAL;
 
-	ret = ath6kl_wmi_force_roam_cmd(ar->wmi, bssid);
+	ret = ath6kl_wmi_force_roam_cmd(ar->wmi, bssid.o);
 	if (ret)
 		return ret;
 
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -5125,7 +5125,7 @@ static void proc_APList_on_close( struct inode *inode, struct file *file ) {
 	APList_rid->len = cpu_to_le16(sizeof(*APList_rid));
 
 	for (i = 0; i < 4 && data->writelen >= (i + 1) * 6 * 3; i++)
-		mac_pton(data->wbuffer + i * 6 * 3, APList_rid->ap[i]);
+		mac_pton(data->wbuffer + i * 6 * 3, (mac_t *)APList_rid->ap[i]);
 
 	disable_MAC(ai, 1);
 	writeAPListRid(ai, APList_rid, 1);
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -626,7 +626,7 @@ static ssize_t iwl_dbgfs_uapsd_misbehaving_write(struct ieee80211_vif *vif,
 	bool ret;
 
 	mutex_lock(&mvm->mutex);
-	ret = mac_pton(buf, mvmvif->uapsd_misbehaving_bssid);
+	ret = mac_pton(buf, (mac_t *)mvmvif->uapsd_misbehaving_bssid);
 	mutex_unlock(&mvm->mutex);
 
 	return ret ? count : -EINVAL;
--- a/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8188eu/core/rtw_ieee80211.c
@@ -893,20 +893,20 @@ enum parse_res rtw_ieee802_11_parse_elems(u8 *start, uint len,
 
 void rtw_macaddr_cfg(u8 *mac_addr)
 {
-	u8 mac[ETH_ALEN];
+	mac_t mac;
 
 	if (!mac_addr)
 		return;
 
-	if (rtw_initmac && mac_pton(rtw_initmac, mac)) {
+	if (rtw_initmac && mac_pton(rtw_initmac, &mac)) {
 		/* Users specify the mac address */
-		ether_addr_copy(mac_addr, mac);
+		ether_addr_copy(mac_addr, mac.o);
 	} else {
 		/* Use the mac address stored in the Efuse */
-		ether_addr_copy(mac, mac_addr);
+		ether_addr_copy(mac.o, mac_addr);
 	}
 
-	if (is_broadcast_ether_addr(mac) || is_zero_ether_addr(mac)) {
+	if (is_broadcast_ether_addr(mac.o) || is_zero_ether_addr(mac.o)) {
 		eth_random_addr(mac_addr);
 		DBG_88E("MAC Address from efuse error, assign random one !!!\n");
 	}
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -1951,7 +1951,7 @@ static int r871x_get_ap_info(struct net_device *dev,
 	unsigned long irqL;
 	struct list_head *plist, *phead;
 	unsigned char *pbuf;
-	u8 bssid[ETH_ALEN];
+	mac_t bssid;
 	char data[33];
 
 	if (padapter->driver_stopped || (pdata == NULL))
@@ -1977,15 +1977,15 @@ static int r871x_get_ap_info(struct net_device *dev,
 		if (end_of_queue_search(phead, plist))
 			break;
 		pnetwork = container_of(plist, struct wlan_network, list);
-		if (!mac_pton(data, bssid)) {
+		if (!mac_pton(data, &bssid)) {
 			netdev_info(dev, "r8712u: Invalid BSSID '%s'.\n",
 				    (u8 *)data);
 			spin_unlock_irqrestore(&(pmlmepriv->scanned_queue.lock),
 					       irqL);
 			return -EINVAL;
 		}
-		netdev_info(dev, "r8712u: BSSID:%pM\n", bssid);
-		if (ether_addr_equal(bssid, pnetwork->network.MacAddress)) {
+		netdev_info(dev, "r8712u: BSSID:%pM\n", &bssid);
+		if (ether_addr_equal(bssid.o, pnetwork->network.MacAddress)) {
 			/* BSSID match, then check if supporting wpa/wpa2 */
 			pbuf = r8712_get_wpa_ie(&pnetwork->network.IEs[12],
 			       &wpa_ielen, pnetwork->network.IELength - 12);
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -394,7 +394,7 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 	/* step 5. read efuse/eeprom data and get mac_addr */
 	{
 		int i, offset;
-		u8 mac[6];
+		mac_t mac;
 		u8 tmpU1b, AutoloadFail, eeprom_CustomerID;
 		u8 *pdata = padapter->eeprompriv.efuse_eeprom_data;
 
@@ -443,11 +443,11 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 				r8712_efuse_pg_packet_read(padapter, offset,
 						     &pdata[i]);
 
-			if (!r8712_initmac || !mac_pton(r8712_initmac, mac)) {
+			if (!r8712_initmac || !mac_pton(r8712_initmac, &mac)) {
 				/* Use the mac address stored in the Efuse
 				 * offset = 0x12 for usb in efuse
 				 */
-				ether_addr_copy(mac, &pdata[0x12]);
+				ether_addr_copy(mac.o, &pdata[0x12]);
 			}
 			eeprom_CustomerID = pdata[0x52];
 			switch (eeprom_CustomerID) {
@@ -541,32 +541,32 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 		} else {
 			AutoloadFail = false;
 		}
-		if (((mac[0] == 0xff) && (mac[1] == 0xff) &&
-		     (mac[2] == 0xff) && (mac[3] == 0xff) &&
-		     (mac[4] == 0xff) && (mac[5] == 0xff)) ||
-		    ((mac[0] == 0x00) && (mac[1] == 0x00) &&
-		     (mac[2] == 0x00) && (mac[3] == 0x00) &&
-		     (mac[4] == 0x00) && (mac[5] == 0x00)) ||
+		if (((mac.o[0] == 0xff) && (mac.o[1] == 0xff) &&
+		     (mac.o[2] == 0xff) && (mac.o[3] == 0xff) &&
+		     (mac.o[4] == 0xff) && (mac.o[5] == 0xff)) ||
+		    ((mac.o[0] == 0x00) && (mac.o[1] == 0x00) &&
+		     (mac.o[2] == 0x00) && (mac.o[3] == 0x00) &&
+		     (mac.o[4] == 0x00) && (mac.o[5] == 0x00)) ||
 		     (!AutoloadFail)) {
-			mac[0] = 0x00;
-			mac[1] = 0xe0;
-			mac[2] = 0x4c;
-			mac[3] = 0x87;
-			mac[4] = 0x00;
-			mac[5] = 0x00;
+			mac.o[0] = 0x00;
+			mac.o[1] = 0xe0;
+			mac.o[2] = 0x4c;
+			mac.o[3] = 0x87;
+			mac.o[4] = 0x00;
+			mac.o[5] = 0x00;
 		}
 		if (r8712_initmac) {
 			/* Make sure the user did not select a multicast
 			 * address by setting bit 1 of first octet.
 			 */
-			mac[0] &= 0xFE;
+			mac.o[0] &= 0xFE;
 			dev_info(&udev->dev,
-				"r8712u: MAC Address from user = %pM\n", mac);
+				"r8712u: MAC Address from user = %pM\n", &mac);
 		} else {
 			dev_info(&udev->dev,
-				"r8712u: MAC Address from efuse = %pM\n", mac);
+				"r8712u: MAC Address from efuse = %pM\n", &mac);
 		}
-		ether_addr_copy(pnetdev->dev_addr, mac);
+		ether_addr_copy(pnetdev->dev_addr, mac.o);
 	}
 	/* step 6. Load the firmware asynchronously */
 	if (rtl871x_load_fw(padapter))
--- a/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
@@ -1100,7 +1100,7 @@ ParseRes rtw_ieee802_11_parse_elems(u8 *start, uint len,
 
 void rtw_macaddr_cfg(struct device *dev, u8 *mac_addr)
 {
-	u8 mac[ETH_ALEN];
+	mac_t mac;
 	struct device_node *np = dev->of_node;
 	const unsigned char *addr;
 	int len;
@@ -1108,15 +1108,15 @@ void rtw_macaddr_cfg(struct device *dev, u8 *mac_addr)
 	if (!mac_addr)
 		return;
 
-	if (rtw_initmac && mac_pton(rtw_initmac, mac)) {
+	if (rtw_initmac && mac_pton(rtw_initmac, &mac)) {
 		/* Users specify the mac address */
-		ether_addr_copy(mac_addr, mac);
+		ether_addr_copy(mac_addr, mac.o);
 	} else {
 		/* Use the mac address stored in the Efuse */
-		ether_addr_copy(mac, mac_addr);
+		ether_addr_copy(mac.o, mac_addr);
 	}
 
-	if (is_broadcast_ether_addr(mac) || is_zero_ether_addr(mac)) {
+	if (is_broadcast_ether_addr(mac.o) || is_zero_ether_addr(mac.o)) {
 		if ((addr = of_get_property(np, "local-mac-address", &len)) &&
 		    len == ETH_ALEN) {
 			ether_addr_copy(mac_addr, addr);
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -2440,7 +2440,7 @@ static int rtw_get_ap_info(struct net_device *dev,
 	u32 cnt = 0, wpa_ielen;
 	struct list_head	*plist, *phead;
 	unsigned char *pbuf;
-	u8 bssid[ETH_ALEN];
+	mac_t bssid;
 	char data[32];
 	struct wlan_network *pnetwork = NULL;
 	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
@@ -2487,15 +2487,15 @@ static int rtw_get_ap_info(struct net_device *dev,
 
 		pnetwork = LIST_CONTAINOR(plist, struct wlan_network, list);
 
-		if (!mac_pton(data, bssid)) {
+		if (!mac_pton(data, &bssid)) {
 			DBG_871X("Invalid BSSID '%s'.\n", (u8 *)data);
 			spin_unlock_bh(&(pmlmepriv->scanned_queue.lock));
 			return -EINVAL;
 		}
 
 
-		if (!memcmp(bssid, pnetwork->network.MacAddress, ETH_ALEN)) { /* BSSID match, then check if supporting wpa/wpa2 */
-			DBG_871X("BSSID:" MAC_FMT "\n", MAC_ARG(bssid));
+		if (!memcmp(&bssid, pnetwork->network.MacAddress, ETH_ALEN)) { /* BSSID match, then check if supporting wpa/wpa2 */
+			DBG_871X("BSSID:" MAC_FMT "\n", MAC_ARG(&bssid));
 
 			pbuf = rtw_get_wpa_ie(&pnetwork->network.IEs[12], &wpa_ielen, pnetwork->network.IELength-12);
 			if (pbuf && (wpa_ielen>0)) {
--- a/drivers/staging/uwb/address.c
+++ b/drivers/staging/uwb/address.c
@@ -322,7 +322,7 @@ static ssize_t uwb_rc_mac_addr_store(struct device *dev,
 	struct uwb_mac_addr addr;
 	ssize_t result;
 
-	if (!mac_pton(buf, addr.data))
+	if (!mac_pton(buf, (mac_t *)addr.data))
 		return -EINVAL;
 	if (is_multicast_ether_addr(addr.data)) {
 		dev_err(&rc->uwb_dev.dev, "refusing to set multicast "
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -25,6 +25,9 @@
 
 #ifdef __KERNEL__
 struct device;
+
+bool mac_pton(const char *s, mac_t *mac);
+
 int eth_platform_get_mac_address(struct device *dev, u8 *mac_addr);
 unsigned char *arch_get_platform_mac_address(void);
 int nvmem_get_mac_address(struct device *dev, void *addrbuf);
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -631,8 +631,6 @@ extern int hex_to_bin(char ch);
 extern int __must_check hex2bin(u8 *dst, const char *src, size_t count);
 extern char *bin2hex(char *dst, const void *src, size_t count);
 
-bool mac_pton(const char *s, u8 *mac);
-
 /*
  * General tracing related utility functions - trace_printk(),
  * tracing_on/tracing_off and tracing_start()/tracing_stop
--- a/include/linux/netpoll.h
+++ b/include/linux/netpoll.h
@@ -30,7 +30,7 @@ struct netpoll {
 	union inet_addr local_ip, remote_ip;
 	bool ipv6;
 	u16 local_port, remote_port;
-	u8 remote_mac[ETH_ALEN];
+	mac_t remote_mac;
 };
 
 struct netpoll_info {
new file mode 100644
--- /dev/null
+++ b/include/net/types.h
@@ -0,0 +1,4 @@
+#pragma once
+typedef struct {
+	unsigned char o[6];
+} mac_t;
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -23,6 +23,9 @@
 #define _UAPI_LINUX_IF_ETHER_H
 
 #include <linux/types.h>
+#ifdef __KERNEL__
+#include <net/types.h>
+#endif
 
 /*
  *	IEEE 802.3 Ethernet magic constants.  The frame sizes omit the preamble
--- a/lib/net_utils.c
+++ b/lib/net_utils.c
@@ -4,7 +4,7 @@
 #include <linux/ctype.h>
 #include <linux/kernel.h>
 
-bool mac_pton(const char *s, u8 *mac)
+bool mac_pton(const char *s, mac_t *mac)
 {
 	int i;
 
@@ -20,7 +20,7 @@ bool mac_pton(const char *s, u8 *mac)
 			return false;
 	}
 	for (i = 0; i < ETH_ALEN; i++) {
-		mac[i] = (hex_to_bin(s[i * 3]) << 4) | hex_to_bin(s[i * 3 + 1]);
+		mac->o[i] = (hex_to_bin(s[i * 3]) << 4) | hex_to_bin(s[i * 3 + 1]);
 	}
 	return true;
 }
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -276,27 +276,27 @@ static ssize_t group_addr_store(struct device *d,
 				const char *buf, size_t len)
 {
 	struct net_bridge *br = to_bridge(d);
-	u8 new_addr[6];
+	mac_t new_addr;
 
 	if (!ns_capable(dev_net(br->dev)->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
-	if (!mac_pton(buf, new_addr))
+	if (!mac_pton(buf, &new_addr))
 		return -EINVAL;
 
-	if (!is_link_local_ether_addr(new_addr))
+	if (!is_link_local_ether_addr(new_addr.o))
 		return -EINVAL;
 
-	if (new_addr[5] == 1 ||		/* 802.3x Pause address */
-	    new_addr[5] == 2 ||		/* 802.3ad Slow protocols */
-	    new_addr[5] == 3)		/* 802.1X PAE address */
+	if (new_addr.o[5] == 1 ||	/* 802.3x Pause address */
+	    new_addr.o[5] == 2 ||	/* 802.3ad Slow protocols */
+	    new_addr.o[5] == 3)		/* 802.1X PAE address */
 		return -EINVAL;
 
 	if (!rtnl_trylock())
 		return restart_syscall();
 
 	spin_lock_bh(&br->lock);
-	ether_addr_copy(br->group_addr, new_addr);
+	ether_addr_copy(br->group_addr, new_addr.o);
 	spin_unlock_bh(&br->lock);
 
 	br_opt_toggle(br, BROPT_GROUP_ADDR_SET, true);
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -454,7 +454,7 @@ void netpoll_send_udp(struct netpoll *np, const char *msg, int len)
 	}
 
 	ether_addr_copy(eth->h_source, np->dev->dev_addr);
-	ether_addr_copy(eth->h_dest, np->remote_mac);
+	ether_addr_copy(eth->h_dest, np->remote_mac.o);
 
 	skb->dev = np->dev;
 
@@ -475,7 +475,7 @@ void netpoll_print_options(struct netpoll *np)
 		np_info(np, "remote IPv6 address %pI6c\n", &np->remote_ip.in6);
 	else
 		np_info(np, "remote IPv4 address %pI4\n", &np->remote_ip.ip);
-	np_info(np, "remote ethernet address %pM\n", np->remote_mac);
+	np_info(np, "remote ethernet address %pM\n", &np->remote_mac);
 }
 EXPORT_SYMBOL(netpoll_print_options);
 
@@ -567,7 +567,7 @@ int netpoll_parse_options(struct netpoll *np, char *opt)
 
 	if (*cur != 0) {
 		/* MAC address */
-		if (!mac_pton(cur, np->remote_mac))
+		if (!mac_pton(cur, &np->remote_mac))
 			goto parse_failed;
 	}
 
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -359,8 +359,8 @@ struct pktgen_dev {
 	__u32 src_mac_count;	/* How many MACs to iterate through */
 	__u32 dst_mac_count;	/* How many MACs to iterate through */
 
-	unsigned char dst_mac[ETH_ALEN];
-	unsigned char src_mac[ETH_ALEN];
+	mac_t dst_mac;
+	mac_t src_mac;
 
 	__u32 cur_dst_mac_offset;
 	__u32 cur_src_mac_offset;
@@ -592,11 +592,11 @@ static int pktgen_if_show(struct seq_file *seq, void *v)
 	seq_puts(seq, "     src_mac: ");
 
 	seq_printf(seq, "%pM ",
-		   is_zero_ether_addr(pkt_dev->src_mac) ?
-			     pkt_dev->odev->dev_addr : pkt_dev->src_mac);
+		   is_zero_ether_addr(pkt_dev->src_mac.o) ?
+			     (mac_t *)pkt_dev->odev->dev_addr : &pkt_dev->src_mac);
 
 	seq_puts(seq, "dst_mac: ");
-	seq_printf(seq, "%pM\n", pkt_dev->dst_mac);
+	seq_printf(seq, "%pM\n", &pkt_dev->dst_mac);
 
 	seq_printf(seq,
 		   "     udp_src_min: %d  udp_src_max: %d"
@@ -1427,12 +1427,12 @@ static ssize_t pktgen_if_write(struct file *file,
 		if (copy_from_user(valstr, &user_buffer[i], len))
 			return -EFAULT;
 
-		if (!mac_pton(valstr, pkt_dev->dst_mac))
+		if (!mac_pton(valstr, &pkt_dev->dst_mac))
 			return -EINVAL;
 		/* Set up Dest MAC */
-		ether_addr_copy(&pkt_dev->hh[0], pkt_dev->dst_mac);
+		ether_addr_copy(&pkt_dev->hh[0], pkt_dev->dst_mac.o);
 
-		sprintf(pg_result, "OK: dstmac %pM", pkt_dev->dst_mac);
+		sprintf(pg_result, "OK: dstmac %pM", &pkt_dev->dst_mac);
 		return count;
 	}
 	if (!strcmp(name, "src_mac")) {
@@ -1444,12 +1444,12 @@ static ssize_t pktgen_if_write(struct file *file,
 		if (copy_from_user(valstr, &user_buffer[i], len))
 			return -EFAULT;
 
-		if (!mac_pton(valstr, pkt_dev->src_mac))
+		if (!mac_pton(valstr, &pkt_dev->src_mac))
 			return -EINVAL;
 		/* Set up Src MAC */
-		ether_addr_copy(&pkt_dev->hh[6], pkt_dev->src_mac);
+		ether_addr_copy(&pkt_dev->hh[6], pkt_dev->src_mac.o);
 
-		sprintf(pg_result, "OK: srcmac %pM", pkt_dev->src_mac);
+		sprintf(pg_result, "OK: srcmac %pM", &pkt_dev->src_mac);
 		return count;
 	}
 
@@ -2050,11 +2050,11 @@ static void pktgen_setup_inject(struct pktgen_dev *pkt_dev)
 
 	/* Default to the interface's mac if not explicitly set. */
 
-	if (is_zero_ether_addr(pkt_dev->src_mac))
+	if (is_zero_ether_addr(pkt_dev->src_mac.o))
 		ether_addr_copy(&(pkt_dev->hh[6]), pkt_dev->odev->dev_addr);
 
 	/* Set up Dest MAC */
-	ether_addr_copy(&(pkt_dev->hh[0]), pkt_dev->dst_mac);
+	ether_addr_copy(&(pkt_dev->hh[0]), pkt_dev->dst_mac.o);
 
 	if (pkt_dev->flags & F_IPV6) {
 		int i, set = 0, err = 1;
@@ -2312,15 +2312,15 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 				pkt_dev->cur_src_mac_offset = 0;
 		}
 
-		tmp = pkt_dev->src_mac[5] + (mc & 0xFF);
+		tmp = pkt_dev->src_mac.o[5] + (mc & 0xFF);
 		pkt_dev->hh[11] = tmp;
-		tmp = (pkt_dev->src_mac[4] + ((mc >> 8) & 0xFF) + (tmp >> 8));
+		tmp = (pkt_dev->src_mac.o[4] + ((mc >> 8) & 0xFF) + (tmp >> 8));
 		pkt_dev->hh[10] = tmp;
-		tmp = (pkt_dev->src_mac[3] + ((mc >> 16) & 0xFF) + (tmp >> 8));
+		tmp = (pkt_dev->src_mac.o[3] + ((mc >> 16) & 0xFF) + (tmp >> 8));
 		pkt_dev->hh[9] = tmp;
-		tmp = (pkt_dev->src_mac[2] + ((mc >> 24) & 0xFF) + (tmp >> 8));
+		tmp = (pkt_dev->src_mac.o[2] + ((mc >> 24) & 0xFF) + (tmp >> 8));
 		pkt_dev->hh[8] = tmp;
-		tmp = (pkt_dev->src_mac[1] + (tmp >> 8));
+		tmp = (pkt_dev->src_mac.o[1] + (tmp >> 8));
 		pkt_dev->hh[7] = tmp;
 	}
 
@@ -2340,15 +2340,15 @@ static void mod_cur_headers(struct pktgen_dev *pkt_dev)
 			}
 		}
 
-		tmp = pkt_dev->dst_mac[5] + (mc & 0xFF);
+		tmp = pkt_dev->dst_mac.o[5] + (mc & 0xFF);
 		pkt_dev->hh[5] = tmp;
-		tmp = (pkt_dev->dst_mac[4] + ((mc >> 8) & 0xFF) + (tmp >> 8));
+		tmp = (pkt_dev->dst_mac.o[4] + ((mc >> 8) & 0xFF) + (tmp >> 8));
 		pkt_dev->hh[4] = tmp;
-		tmp = (pkt_dev->dst_mac[3] + ((mc >> 16) & 0xFF) + (tmp >> 8));
+		tmp = (pkt_dev->dst_mac.o[3] + ((mc >> 16) & 0xFF) + (tmp >> 8));
 		pkt_dev->hh[3] = tmp;
-		tmp = (pkt_dev->dst_mac[2] + ((mc >> 24) & 0xFF) + (tmp >> 8));
+		tmp = (pkt_dev->dst_mac.o[2] + ((mc >> 24) & 0xFF) + (tmp >> 8));
 		pkt_dev->hh[2] = tmp;
-		tmp = (pkt_dev->dst_mac[1] + (tmp >> 8));
+		tmp = (pkt_dev->dst_mac.o[1] + (tmp >> 8));
 		pkt_dev->hh[1] = tmp;
 	}
 
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -311,12 +311,12 @@ static ssize_t ieee80211_if_parse_tkip_mic_test(
 	struct ieee80211_sub_if_data *sdata, const char *buf, int buflen)
 {
 	struct ieee80211_local *local = sdata->local;
-	u8 addr[ETH_ALEN];
+	mac_t addr;
 	struct sk_buff *skb;
 	struct ieee80211_hdr *hdr;
 	__le16 fc;
 
-	if (!mac_pton(buf, addr))
+	if (!mac_pton(buf, &addr))
 		return -EINVAL;
 
 	if (!ieee80211_sdata_running(sdata))
@@ -334,7 +334,7 @@ static ssize_t ieee80211_if_parse_tkip_mic_test(
 	case NL80211_IFTYPE_AP:
 		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS);
 		/* DA BSSID SA */
-		memcpy(hdr->addr1, addr, ETH_ALEN);
+		memcpy(hdr->addr1, addr.o, ETH_ALEN);
 		memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
 		memcpy(hdr->addr3, sdata->vif.addr, ETH_ALEN);
 		break;
@@ -349,7 +349,7 @@ static ssize_t ieee80211_if_parse_tkip_mic_test(
 		}
 		memcpy(hdr->addr1, sdata->u.mgd.associated->bssid, ETH_ALEN);
 		memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
-		memcpy(hdr->addr3, addr, ETH_ALEN);
+		memcpy(hdr->addr3, addr.o, ETH_ALEN);
 		sdata_unlock(sdata);
 		break;
 	default:
