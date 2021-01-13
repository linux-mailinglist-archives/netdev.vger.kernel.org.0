Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853542F4CAB
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 15:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbhAMOCC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 13 Jan 2021 09:02:02 -0500
Received: from mail.savoirfairelinux.com ([208.88.110.44]:46878 "EHLO
        mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbhAMOCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 09:02:01 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 1099E9C0DC1;
        Wed, 13 Jan 2021 09:01:20 -0500 (EST)
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id dEgDgiRf_U4e; Wed, 13 Jan 2021 09:01:19 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 716FE9C0DD5;
        Wed, 13 Jan 2021 09:01:19 -0500 (EST)
X-Virus-Scanned: amavisd-new at mail.savoirfairelinux.com
Received: from mail.savoirfairelinux.com ([127.0.0.1])
        by localhost (mail.savoirfairelinux.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ijHyM6KBQP8K; Wed, 13 Jan 2021 09:01:19 -0500 (EST)
Received: from mail.savoirfairelinux.com (mail.savoirfairelinux.com [192.168.48.237])
        by mail.savoirfairelinux.com (Postfix) with ESMTP id 468639C0DC1;
        Wed, 13 Jan 2021 09:01:19 -0500 (EST)
Date:   Wed, 13 Jan 2021 09:01:19 -0500 (EST)
From:   Gilles Doffe <gilles.doffe@savoirfairelinux.com>
To:     netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <309642574.258062.1610546479144.JavaMail.zimbra@savoirfairelinux.com>
In-Reply-To: <c5c35fb4a3e4784a5e26a7b7181a0a2925674712.1610540603.git.gilles.doffe@savoirfairelinux.com>
References: <cover.1610540603.git.gilles.doffe@savoirfairelinux.com> <c5c35fb4a3e4784a5e26a7b7181a0a2925674712.1610540603.git.gilles.doffe@savoirfairelinux.com>
Subject: Re: [PATCH net 1/6] net: dsa: ksz: fix FID management
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Mailer: Zimbra 8.8.15_GA_3991 (ZimbraWebClient - GC87 (Linux)/8.8.15_GA_3980)
Thread-Topic: fix FID management
Thread-Index: dwYe9SMrlEHtiii9DTEZkWte16xAwA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- Le 13 Jan 21, à 13:45, Gilles Doffe gilles.doffe@savoirfairelinux.com a écrit :

> The FID (Filter ID) is a 7 bits field used to link the VLAN table
> to the static and dynamic mac address tables.
> Until now the KSZ8795 driver could only add one VLAN as the FID was
> always set to 1.
> This commit allows setting a FID for each new active VLAN.
> The FID list is stored in a static table dynamically allocated from
> ks8795_fid structure.
> Each newly activated VLAN is associated to the next available FID.
> Only the VLAN 0 is not added to the list as it is a special VLAN.
> As it has a special meaning, see IEEE 802.1q.
> When a VLAN is no more used, the associated FID table entry is reset
> to 0.
> 
> Signed-off-by: Gilles DOFFE <gilles.doffe@savoirfairelinux.com>
> ---
> drivers/net/dsa/microchip/ksz8795.c     | 59 +++++++++++++++++++++++--
> drivers/net/dsa/microchip/ksz8795_reg.h |  1 +
> drivers/net/dsa/microchip/ksz_common.h  |  1 +
> 3 files changed, 57 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795.c
> b/drivers/net/dsa/microchip/ksz8795.c
> index c973db101b72..6962ba4ee125 100644
> --- a/drivers/net/dsa/microchip/ksz8795.c
> +++ b/drivers/net/dsa/microchip/ksz8795.c
> @@ -648,7 +648,7 @@ static enum dsa_tag_protocol ksz8795_get_tag_protocol(struct
> dsa_switch *ds,
> 						      int port,
> 						      enum dsa_tag_protocol mp)
> {
> -	return DSA_TAG_PROTO_KSZ8795;
> +	return DSA_TAG_PROTO_NONE;

This is an oversight, will be removed in V2.

> }
> 
> static void ksz8795_get_strings(struct dsa_switch *ds, int port,
> @@ -796,6 +796,41 @@ static int ksz8795_port_vlan_filtering(struct dsa_switch
> *ds, int port,
> 	return 0;
> }
> 
> +static void ksz8795_del_fid(u16 *ksz_fid_table, u16 vid)
> +{
> +	u8 i = 0;
> +
> +	if (!ksz_fid_table)
> +		return;
> +
> +	for (i = 0; i < VLAN_TABLE_FID_SIZE; i++) {
> +		if (ksz_fid_table[i] == vid) {
> +			ksz_fid_table[i] = 0;
> +			break;
> +		}
> +	}
> +}
> +
> +static int ksz8795_get_next_fid(u16 *ksz_fid_table, u16 vid, u8 *fid)
> +{
> +	u8 i = 0;
> +	int ret = -EOVERFLOW;
> +
> +	if (!ksz_fid_table)
> +		return ret;
> +
> +	for (i = 0; i < VLAN_TABLE_FID_SIZE; i++) {
> +		if (!ksz_fid_table[i]) {
> +			ksz_fid_table[i] = vid;
> +			*fid = i;
> +			ret = 0;
> +			break;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> static void ksz8795_port_vlan_add(struct dsa_switch *ds, int port,
> 				  const struct switchdev_obj_port_vlan *vlan)
> {
> @@ -803,17 +838,24 @@ static void ksz8795_port_vlan_add(struct dsa_switch *ds,
> int port,
> 	struct ksz_device *dev = ds->priv;
> 	u16 data, vid, new_pvid = 0;
> 	u8 fid, member, valid;
> +	int ret;
> 
> 	ksz_port_cfg(dev, port, P_TAG_CTRL, PORT_REMOVE_TAG, untagged);
> 
> 	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
> +		if (vid == 0)
> +			continue;
> +
> 		ksz8795_r_vlan_table(dev, vid, &data);
> 		ksz8795_from_vlan(data, &fid, &member, &valid);
> 
> 		/* First time to setup the VLAN entry. */
> 		if (!valid) {
> -			/* Need to find a way to map VID to FID. */
> -			fid = 1;
> +			ret = ksz8795_get_next_fid(dev->ksz_fid_table, vid, &fid);
> +			if (ret) {
> +				dev_err(ds->dev, "Switch FID table is full, cannot add");
> +				return;
> +			}
> 			valid = 1;
> 		}
> 		member |= BIT(port);
> @@ -855,7 +897,7 @@ static int ksz8795_port_vlan_del(struct dsa_switch *ds, int
> port,
> 
> 		/* Invalidate the entry if no more member. */
> 		if (!member) {
> -			fid = 0;
> +			ksz8795_del_fid(dev->ksz_fid_table, vid);
> 			valid = 0;
> 		}
> 
> @@ -1087,6 +1129,9 @@ static int ksz8795_setup(struct dsa_switch *ds)
> 	for (i = 0; i < (dev->num_vlans / 4); i++)
> 		ksz8795_r_vlan_entries(dev, i);
> 
> +	/* Assign first FID to VLAN 1 and always return FID=0 for this vlan */
> +	dev->ksz_fid_table[0] = 1;
> +
> 	/* Setup STP address for STP operation. */
> 	memset(&alu, 0, sizeof(alu));
> 	ether_addr_copy(alu.mac, eth_stp_addr);
> @@ -1261,6 +1306,12 @@ static int ksz8795_switch_init(struct ksz_device *dev)
> 	/* set the real number of ports */
> 	dev->ds->num_ports = dev->port_cnt;
> 
> +	dev->ksz_fid_table = devm_kzalloc(dev->dev,
> +					  VLAN_TABLE_FID_SIZE * sizeof(u16),
> +					  GFP_KERNEL);
> +	if (!dev->ksz_fid_table)
> +		return -ENOMEM;
> +
> 	return 0;
> }
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795_reg.h
> b/drivers/net/dsa/microchip/ksz8795_reg.h
> index 40372047d40d..fe4c4f7fdd47 100644
> --- a/drivers/net/dsa/microchip/ksz8795_reg.h
> +++ b/drivers/net/dsa/microchip/ksz8795_reg.h
> @@ -915,6 +915,7 @@
>  */
> 
> #define VLAN_TABLE_FID			0x007F
> +#define VLAN_TABLE_FID_SIZE		128
> #define VLAN_TABLE_MEMBERSHIP		0x0F80
> #define VLAN_TABLE_VALID		0x1000
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.h
> b/drivers/net/dsa/microchip/ksz_common.h
> index 720f22275c84..44e97c55c2da 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -77,6 +77,7 @@ struct ksz_device {
> 	bool synclko_125;
> 
> 	struct vlan_table *vlan_cache;
> +	u16 *ksz_fid_table;
> 
> 	struct ksz_port *ports;
> 	struct delayed_work mib_read;
> --
> 2.25.1
