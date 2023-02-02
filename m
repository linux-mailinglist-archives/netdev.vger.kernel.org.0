Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B9368759A
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 06:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbjBBFwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 00:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbjBBFvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 00:51:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFF91C59D
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 21:51:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 266B1615F1
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 05:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A02C433EF;
        Thu,  2 Feb 2023 05:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675317073;
        bh=SEgh2OyDzwVFe2xC4jVGp0dKEzVjBEDNb8e9no98WTM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=goTUbdsUyYJpqAQ9sMgyiD9cp/hUEJQsSZt8yrgTj7t4Vsyyh3vYGR/ZNrcdrdgGa
         y2xD4j38es2iv5mYibtlU3vKpTwqEmz10nYAv3NnrcNLUNqKxcHnT8qgoe/nCSy1Gi
         ksgWspkNGcCGvXrppU3mJeaoOOhW7M76A9nZr951zY9XdbH1qz9pXsJuX/u0xpD918
         yiQ7p91VQJ5AKGJi2s1jRaepNibnY6dWrATNmQ81NgndvTYLEjjgkgm3RXhldspt8T
         HVGfHCXFnF8AFam6ayUajRRt3crmXHw77Uhuax2X2ZJ/rS0AlylDxGb7szI4fzYtnN
         +7N5t96WEr4hw==
Date:   Wed, 1 Feb 2023 21:51:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
Subject: Re: [PATCH net-next v2 05/10] net: libwx: Allocate Rx and Tx
 resources
Message-ID: <20230201215112.37a72893@kernel.org>
In-Reply-To: <20230131100541.73757-6-mengyuanlou@net-swift.com>
References: <20230131100541.73757-1-mengyuanlou@net-swift.com>
        <20230131100541.73757-6-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Jan 2023 18:05:36 +0800 Mengyuan Lou wrote:
> +/* Transmit Descriptor */
> +union wx_tx_desc {
> +	struct {
> +		__le64 buffer_addr; /* Address of descriptor's data buf */
> +		__le32 cmd_type_len;
> +		__le32 olinfo_status;
> +	} read;
> +	struct {
> +		__le64 rsvd; /* Reserved */
> +		__le32 nxtseq_seed;
> +		__le32 status;
> +	} wb;
> +};
> +
> +/* Receive Descriptor */
> +union wx_rx_desc {
> +	struct {
> +		__le64 pkt_addr; /* Packet buffer address */
> +		__le64 hdr_addr; /* Header buffer address */
> +	} read;
> +	struct {
> +		struct {
> +			union {
> +				__le32 data;
> +				struct {
> +					__le16 pkt_info; /* RSS, Pkt type */
> +					__le16 hdr_info; /* Splithdr, hdrlen */
> +				} hs_rss;
> +			} lo_dword;
> +			union {
> +				__le32 rss; /* RSS Hash */
> +				struct {
> +					__le16 ip_id; /* IP id */
> +					__le16 csum; /* Packet Checksum */
> +				} csum_ip;
> +			} hi_dword;
> +		} lower;
> +		struct {
> +			__le32 status_error; /* ext status/error */
> +			__le16 length; /* Packet length */
> +			__le16 vlan; /* VLAN tag */
> +		} upper;
> +	} wb;  /* writeback */
> +};

How close of a copy of Intel Niantic is your device?
