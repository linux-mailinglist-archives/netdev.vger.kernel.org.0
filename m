Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A902C3430
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 23:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390015AbgKXWn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 17:43:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:56030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgKXWn4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 17:43:56 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7140C206D4;
        Tue, 24 Nov 2020 22:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606257834;
        bh=1Luz3E29AIffRwBhr81HenyYu8mhB/BAK65N+Kn/S54=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WpJZdDvZeQMQt2KBymrc6QvatNCC0nd4M0lD8C0DtljlsqW30XFG+AwClwuDXK5he
         s5SiYl3S9Kne6k6AIyET+tI8nxYIrvICxtdYmexS/MtxAV1NL0RasiX2/P3PKHAu5x
         sPfvTb61Q/54n9RgBxHBVYrxSMfo+BSmsIfJ6+Lw=
Date:   Tue, 24 Nov 2020 14:43:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bongsu Jeon <bongsu.jeon@samsung.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-nfc@lists.01.org
Subject: Re: [PATCH net-next v2] net/nfc/nci: Support NCI 2.x initial
 sequence
Message-ID: <20201124144353.7c759cae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201123101208epcms2p71d4c8d66f08fb7a2e10ae422abde3389@epcms2p7>
References: <CGME20201123101208epcms2p71d4c8d66f08fb7a2e10ae422abde3389@epcms2p7>
        <20201123101208epcms2p71d4c8d66f08fb7a2e10ae422abde3389@epcms2p7>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 19:12:08 +0900 Bongsu Jeon wrote:
> implement the NCI 2.x initial sequence to support NCI 2.x NFCC.
> Since NCI 2.0, CORE_RESET and CORE_INIT sequence have been changed.
> If NFCEE supports NCI 2.x, then NCI 2.x initial sequence will work.
> 
> In NCI 1.0, Initial sequence and payloads are as below:
> (DH)                     (NFCC)
>  |  -- CORE_RESET_CMD --> |
>  |  <-- CORE_RESET_RSP -- |
>  |  -- CORE_INIT_CMD -->  |
>  |  <-- CORE_INIT_RSP --  |
>  CORE_RESET_RSP payloads are Status, NCI version, Configuration Status.
>  CORE_INIT_CMD payloads are empty.
>  CORE_INIT_RSP payloads are Status, NFCC Features,
>     Number of Supported RF Interfaces, Supported RF Interface,
>     Max Logical Connections, Max Routing table Size,
>     Max Control Packet Payload Size, Max Size for Large Parameters,
>     Manufacturer ID, Manufacturer Specific Information.
> 
> In NCI 2.0, Initial Sequence and Parameters are as below:
> (DH)                     (NFCC)
>  |  -- CORE_RESET_CMD --> |
>  |  <-- CORE_RESET_RSP -- |
>  |  <-- CORE_RESET_NTF -- |
>  |  -- CORE_INIT_CMD -->  |
>  |  <-- CORE_INIT_RSP --  |
>  CORE_RESET_RSP payloads are Status.
>  CORE_RESET_NTF payloads are Reset Trigger,
>     Configuration Status, NCI Version, Manufacturer ID,
>     Manufacturer Specific Information Length,
>     Manufacturer Specific Information.
>  CORE_INIT_CMD payloads are Feature1, Feature2.
>  CORE_INIT_RSP payloads are Status, NFCC Features,
>     Max Logical Connections, Max Routing Table Size,
>     Max Control Packet Payload Size,
>     Max Data Packet Payload Size of the Static HCI Connection,
>     Number of Credits of the Static HCI Connection,
>     Max NFC-V RF Frame Size, Number of Supported RF Interfaces,
>     Supported RF Interfaces.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>

NFC folks, looks like when the NFC core got orphaned it lost all links
in MAINTAINERS. Should we add the L: linux-nfc@lists.01.org so that
there is a better chance that someone knowledgeable will provide
reviews?

Also if anyone is up for it feel free to add your M: or R: entries!

>  #define NCI_OP_CORE_INIT_CMD		nci_opcode_pack(NCI_GID_CORE, 0x01)
> +/* To support NCI 2.x */
> +struct nci_core_init_v2_cmd {
> +	unsigned char	feature1;
> +	unsigned char	feature2;
> +} __packed;

No need for this to be packed.

>  #define NCI_OP_CORE_SET_CONFIG_CMD	nci_opcode_pack(NCI_GID_CORE, 0x02)
>  struct set_config_param {
> @@ -316,6 +326,11 @@ struct nci_core_reset_rsp {
>  	__u8	config_status;
>  } __packed;
>  
> +/* To support NCI ver 2.x */
> +struct nci_core_reset_rsp_nci_ver2 {
> +	unsigned char	status;
> +} __packed;

ditto

>  #define NCI_OP_CORE_INIT_RSP		nci_opcode_pack(NCI_GID_CORE, 0x01)
>  struct nci_core_init_rsp_1 {
>  	__u8	status;
> @@ -334,6 +349,20 @@ struct nci_core_init_rsp_2 {
>  	__le32	manufact_specific_info;
>  } __packed;
>  
> +/* To support NCI ver 2.x */
> +struct nci_core_init_rsp_nci_ver2 {
> +	unsigned char	status;
> +	__le32	nfcc_features;
> +	unsigned char	max_logical_connections;
> +	__le16	max_routing_table_size;
> +	unsigned char	max_ctrl_pkt_payload_len;
> +	unsigned char	max_data_pkt_hci_payload_len;
> +	unsigned char	number_of_hci_credit;
> +	__le16	max_nfc_v_frame_size;
> +	unsigned char	num_supported_rf_interfaces;
> +	unsigned char	supported_rf_interfaces[];
> +} __packed;
> +
>  #define NCI_OP_CORE_SET_CONFIG_RSP	nci_opcode_pack(NCI_GID_CORE, 0x02)
>  struct nci_core_set_config_rsp {
>  	__u8	status;
> @@ -372,6 +401,16 @@ struct nci_nfcee_discover_rsp {
>  /* --------------------------- */
>  /* ---- NCI Notifications ---- */
>  /* --------------------------- */
> +#define NCI_OP_CORE_RESET_NTF		nci_opcode_pack(NCI_GID_CORE, 0x00)
> +struct nci_core_reset_ntf {
> +	unsigned char	reset_trigger;
> +	unsigned char	config_status;
> +	unsigned char	nci_ver;
> +	unsigned char	manufact_id;
> +	unsigned char	manufacturer_specific_len;
> +	__le32	manufact_specific_info;
> +} __packed;
> +
>  #define NCI_OP_CORE_CONN_CREDITS_NTF	nci_opcode_pack(NCI_GID_CORE, 0x06)
>  struct conn_credit_entry {
>  	__u8	conn_id;
> diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
> index 4953ee5146e1..68889faadda2 100644
> --- a/net/nfc/nci/core.c
> +++ b/net/nfc/nci/core.c
> @@ -165,7 +165,14 @@ static void nci_reset_req(struct nci_dev *ndev, unsigned long opt)
>  
>  static void nci_init_req(struct nci_dev *ndev, unsigned long opt)
>  {
> -	nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, 0, NULL);
> +	struct nci_core_init_v2_cmd *cmd = (struct nci_core_init_v2_cmd *)opt;
> +
> +	if (!cmd) {
> +		nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, 0, NULL);
> +	} else {
> +		/* if nci version is 2.0, then use the feature parameters */
> +		nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, sizeof(struct nci_core_init_v2_cmd), cmd);

Please wrap this line.

> +	}

Parenthesis unnecessary.

>  }
>  
>  static void nci_init_complete_req(struct nci_dev *ndev, unsigned long opt)

> +static unsigned char nci_core_init_rsp_packet_v2(struct nci_dev *ndev, struct sk_buff *skb)
> +{
> +	struct nci_core_init_rsp_nci_ver2 *rsp = (void *)skb->data;
> +	unsigned char rf_interface_idx = 0;
> +	unsigned char rf_extension_cnt = 0;
> +	unsigned char *supported_rf_interface = rsp->supported_rf_interfaces;
> +
> +	pr_debug("status %x\n", rsp->status);
> +
> +	if (rsp->status != NCI_STATUS_OK)
> +		return rsp->status;
> +
> +	ndev->nfcc_features = __le32_to_cpu(rsp->nfcc_features);
> +	ndev->num_supported_rf_interfaces = rsp->num_supported_rf_interfaces;
> +
> +	if (ndev->num_supported_rf_interfaces >
> +	    NCI_MAX_SUPPORTED_RF_INTERFACES) {
> +		ndev->num_supported_rf_interfaces =
> +			NCI_MAX_SUPPORTED_RF_INTERFACES;
> +	}

brackets unnecessary unnecessary 

also:

	ndev->num_supported_rf_interfaces =
		min(ndev->num_supported_rf_interfaces,
		    NCI_MAX_SUPPORTED_RF_INTERFACES);

> +	while (rf_interface_idx < ndev->num_supported_rf_interfaces) {
> +		ndev->supported_rf_interfaces[rf_interface_idx++] = *supported_rf_interface++;
> +
> +		/* skip rf extension parameters */
> +		rf_extension_cnt = *supported_rf_interface++;
> +		supported_rf_interface += rf_extension_cnt;
> +	}
