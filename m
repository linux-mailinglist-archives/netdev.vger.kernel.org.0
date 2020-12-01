Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECF52C956B
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 03:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgLACt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 21:49:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:42420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgLACt2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 21:49:28 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B91620809;
        Tue,  1 Dec 2020 02:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606790926;
        bh=H6e0oqcPK0U5uZ5zajusrZhvNPrGpQvXS7M5mrhdYUs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j6nnp4c69RboxrK59+msqLt0WGuzUmD7Q1ft+xkkF1fGFkLwaA1JraLZf9tQAmhWH
         m7+5sODI2zo7nv9ANRuNLhKB5V67SI8Fagf+DUeo1y+ncZRZljVi75OBGTYZ6bJcvk
         sfyzS/tAOnEV5pHxo3kwkKZdpy6fGamPLtQzuG/o=
Date:   Mon, 30 Nov 2020 18:48:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     bongsu.jeon2@gmail.com
Cc:     linux-nfc@lists.01.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH net-next v3] net/nfc/nci: Support NCI 2.x initial
 sequence
Message-ID: <20201130184845.304f54d3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <5fc100ec.1c69fb81.58b7b.2dee@mx.google.com>
References: <5fc100ec.1c69fb81.58b7b.2dee@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 22:36:31 +0900 bongsu.jeon2@gmail.com wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
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

>  static void nci_init_req(struct nci_dev *ndev, unsigned long opt)
>  {
> -	nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, 0, NULL);
> +	struct nci_core_init_v2_cmd *cmd = (struct nci_core_init_v2_cmd *)opt;
> +
> +	if (!cmd)
> +		nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, 0, NULL);
> +	else
> +		/* if nci version is 2.0, then use the feature parameters */
> +		nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD,
> +			     sizeof(struct nci_core_init_v2_cmd), cmd);

This would be better written as:

	u8 plen = 0;

	if (opt)
		plen = sizeof(struct nci_core_init_v2_cmd);
	
	nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, plen, (void *)opt);

> +

unnecessary empty line

>  }
>  
>  static void nci_init_complete_req(struct nci_dev *ndev, unsigned long opt)
> @@ -497,8 +505,18 @@ static int nci_open_device(struct nci_dev *ndev)
>  	}
>  
>  	if (!rc) {
> -		rc = __nci_request(ndev, nci_init_req, 0,
> -				   msecs_to_jiffies(NCI_INIT_TIMEOUT));
> +		if (!(ndev->nci_ver & NCI_VER_2_MASK)) {
> +			rc = __nci_request(ndev, nci_init_req, 0,
> +					   msecs_to_jiffies(NCI_INIT_TIMEOUT));
> +		} else {
> +			struct nci_core_init_v2_cmd nci_init_v2_cmd;
> +
> +			nci_init_v2_cmd.feature1 = NCI_FEATURE_DISABLE;
> +			nci_init_v2_cmd.feature2 = NCI_FEATURE_DISABLE;
> +
> +			rc = __nci_request(ndev, nci_init_req, (unsigned long)&nci_init_v2_cmd,
> +					   msecs_to_jiffies(NCI_INIT_TIMEOUT));
> +		}

again please try to pull out the common code:

	struct nci_core_init_v2_cmd nci_init_v2_cmd = {
		.feature1 = NCI_FEATURE_DISABLE;
		.feature2 = NCI_FEATURE_DISABLE;
	};
	unsigned long opt = 0;
	
	if (ndev->nci_ver & NCI_VER_2_MASK)
		opt = (unsigned long)&nci_init_v2_cmd;

	rc = __nci_request(ndev, nci_init_req, opt,
			   msecs_to_jiffies(NCI_INIT_TIMEOUT));
	

>  	}

> -static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
> +static unsigned char nci_core_init_rsp_packet_v1(struct nci_dev *ndev, struct sk_buff *skb)
>  {
>  	struct nci_core_init_rsp_1 *rsp_1 = (void *) skb->data;
>  	struct nci_core_init_rsp_2 *rsp_2;
> @@ -48,16 +51,14 @@ static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
>  	pr_debug("status 0x%x\n", rsp_1->status);
>  
>  	if (rsp_1->status != NCI_STATUS_OK)
> -		goto exit;
> +		return rsp_1->status;
>  
>  	ndev->nfcc_features = __le32_to_cpu(rsp_1->nfcc_features);
>  	ndev->num_supported_rf_interfaces = rsp_1->num_supported_rf_interfaces;
>  
> -	if (ndev->num_supported_rf_interfaces >
> -	    NCI_MAX_SUPPORTED_RF_INTERFACES) {
> -		ndev->num_supported_rf_interfaces =
> -			NCI_MAX_SUPPORTED_RF_INTERFACES;
> -	}
> +	ndev->num_supported_rf_interfaces =
> +		min((int)ndev->num_supported_rf_interfaces,
> +		    NCI_MAX_SUPPORTED_RF_INTERFACES);
>  
>  	memcpy(ndev->supported_rf_interfaces,
>  	       rsp_1->supported_rf_interfaces,
> @@ -77,6 +78,58 @@ static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
>  	ndev->manufact_specific_info =
>  		__le32_to_cpu(rsp_2->manufact_specific_info);
>  
> +	return NCI_STATUS_OK;
> +}
> +
> +static unsigned char nci_core_init_rsp_packet_v2(struct nci_dev *ndev, struct sk_buff *skb)
> +{
> +	struct nci_core_init_rsp_nci_ver2 *rsp = (void *)skb->data;
> +	unsigned char rf_interface_idx = 0;

Prefer the use of u8 type in the kernel

> +	unsigned char rf_extension_cnt = 0;
> +	unsigned char *supported_rf_interface = rsp->supported_rf_interfaces;

Please order the variable declarations longest to shortest.
Don't initialize them inline if that'd cause the order to break.

> +	pr_debug("status %x\n", rsp->status);
> +
> +	if (rsp->status != NCI_STATUS_OK)
> +		return rsp->status;
> +
