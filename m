Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87BFB4C43DC
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 12:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237426AbiBYLru (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 06:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234885AbiBYLru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 06:47:50 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BF480206;
        Fri, 25 Feb 2022 03:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645789638; x=1677325638;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=/6U9OUaFd25ZGXX0FwzC82VbYuWnUZhaMfeCaqdQJ+k=;
  b=Mbui8b++2hyTDMkkj4cy2kgt++Mm52wKwQlF5SIPiATqFPBUhP0P10Om
   +DDxhg87Suw8TaAyievQVtyuA6tRT/0B75T5V4HHDv7eR6RAyf5EtYYiQ
   2l06XZGlYlwhyc064qQSpWZgl9NOv5emRpJp3yj21WKpoQFFO82PicpCd
   oqhz4ZGLiO1tA57KThvlVNB1KWCSGfKgl6BN9mc8a8hPiD/XpDTLRmXOe
   8+1dldXsSDNoP2gcP8YHCxDY5yEreqfg74Ks9Hg0IBqHSzqefld6NwUhu
   os+NkqnotESN2WuGB49LMpwbxgQTzBSLikIAhKOcbHJdQ5OrvTlOVjcq2
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10268"; a="232454148"
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="232454148"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 03:47:17 -0800
X-IronPort-AV: E=Sophos;i="5.90,136,1643702400"; 
   d="scan'208";a="509248610"
Received: from grossi-mobl.ger.corp.intel.com ([10.252.47.60])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 03:47:11 -0800
Date:   Fri, 25 Feb 2022 13:47:09 +0200 (EET)
From:   =?ISO-8859-15?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
To:     Ricardo Martinez <ricardo.martinez@linux.intel.com>
cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        moises.veleta@intel.com, pierre-louis.bossart@intel.com,
        muralidharan.sethuraman@intel.com, Soumya.Prakash.Mishra@intel.com,
        sreehari.kancharla@intel.com, madhusmita.sahu@intel.com
Subject: Re: [PATCH net-next v5 04/13] net: wwan: t7xx: Add port proxy
 infrastructure
In-Reply-To: <20220223223326.28021-5-ricardo.martinez@linux.intel.com>
Message-ID: <b7b7c5d1-e6c8-4c74-d5aa-b12443d5aee@linux.intel.com>
References: <20220223223326.28021-1-ricardo.martinez@linux.intel.com> <20220223223326.28021-5-ricardo.martinez@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Feb 2022, Ricardo Martinez wrote:

> From: Haijun Liu <haijun.liu@mediatek.com>
> 
> Port-proxy provides a common interface to interact with different types
> of ports. Ports export their configuration via `struct t7xx_port` and
> operate as defined by `struct port_ops`.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Co-developed-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
> Co-developed-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> 
> >From a WWAN framework perspective:
> Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
> ---


> +static u16 t7xx_port_next_rx_seq_num(struct t7xx_port *port, struct ccci_header *ccci_h)
> +{
> +	u16 seq_num, next_seq_num, assert_bit;

assert_bit could be bool.

> +
> +	seq_num = FIELD_GET(CCCI_H_SEQ_FLD, le32_to_cpu(ccci_h->status));
> +	next_seq_num = (seq_num + 1) & FIELD_MAX(CCCI_H_SEQ_FLD);
> +	assert_bit = !!(le32_to_cpu(ccci_h->status) & CCCI_H_AST_BIT);
> +	if (!assert_bit || port->seq_nums[MTK_RX] > FIELD_MAX(CCCI_H_SEQ_FLD))

Is this an obfuscated way to say:
	... || port->seq_nums[MTK_RX] == INVALID_SEQ_NUM
?

> +int t7xx_port_proxy_node_control(struct t7xx_modem *md, struct port_msg *port_msg)
> +{
> +	u32 *port_info_base = (void *)port_msg + sizeof(*port_msg);

__le32 *port_info_base = (void *)port_msg + sizeof(*port_msg);

As port_msg has __le32 fields, the endianess likely should disappear in 
this casting?

> +	struct device *dev = &md->t7xx_dev->pdev->dev;
> +	unsigned int version, ports, i;
> +
> +	version = FIELD_GET(PORT_MSG_VERSION, le32_to_cpu(port_msg->info));
> +	if (version != PORT_ENUM_VER ||
> +	    le32_to_cpu(port_msg->head_pattern) != PORT_ENUM_HEAD_PATTERN ||
> +	    le32_to_cpu(port_msg->tail_pattern) != PORT_ENUM_TAIL_PATTERN) {
> +		dev_err(dev, "Invalid port control message %x:%x:%x\n",
> +			version, le32_to_cpu(port_msg->head_pattern),
> +			le32_to_cpu(port_msg->tail_pattern));
> +		return -EFAULT;
> +	}
> +
> +	ports = FIELD_GET(PORT_MSG_PRT_CNT, le32_to_cpu(port_msg->info));
> +	for (i = 0; i < ports; i++) {
> +		struct t7xx_port_static *port_static;
> +		u32 *port_info = port_info_base + i;

__le32 *port_info = port_info_base + i;

> +		struct t7xx_port *port;
> +		unsigned int ch_id;
> +		bool en_flag;
> +
> +		ch_id = FIELD_GET(PORT_INFO_CH_ID, *port_info);

ch_id = FIELD_GET(PORT_INFO_CH_ID, le32_to_cpu(*port_info));

> +		port = t7xx_proxy_get_port_by_ch(md->port_prox, ch_id);
> +		if (!port) {
> +			dev_dbg(dev, "Port:%x not found\n", ch_id);
> +			continue;
> +		}
> +
> +		en_flag = !!(PORT_INFO_ENFLG & *port_info);

*port_info & PORT_INFO_ENFLG


-- 
 i.

