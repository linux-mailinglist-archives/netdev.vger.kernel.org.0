Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A7D6F1A1F
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 16:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbjD1OBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 10:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjD1OBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 10:01:40 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6D94690
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 07:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bNL5D4yCZcP8tySqqCeuSQxYMFuwUCZEYRBtXAfPJW4=; b=5sJtcm+x5zjfcPgO0xKpKfZVJm
        0LFE11JUl8htTxbnWjuEKqadU+jwMsMTGmx+6uCrv0hKFVlVCoft0eRmul3Bsf/jQsSX9QxUliULU
        QPwL3iDdeTQl89vNSSKmeGcEUhf8HeAbp3FEnelNE1JIYtpErUo6diECzT7zNXQZN1jU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1psOfG-00BQ8u-3Y; Fri, 28 Apr 2023 16:01:34 +0200
Date:   Fri, 28 Apr 2023 16:01:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Moreton <andy.moreton@amd.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
Subject: Re: [PATCH net] sfc: Fix module EEPROM reporting for QSFP modules
Message-ID: <67ecea44-2190-4aa4-9439-6e24013674c0@lunn.ch>
References: <168268161289.12077.6557674540677231817.stgit@xcbamoreton41x.xlnx.xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168268161289.12077.6557674540677231817.stgit@xcbamoreton41x.xlnx.xilinx.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 12:33:33PM +0100, Andy Moreton wrote:
> The sfc driver does not report QSFP module EEPROM contents correctly
> as only the first page is fetched from hardware.
> 
> Commit 0e1a2a3e6e7d ("ethtool: Add SFF-8436 and SFF-8636 max EEPROM
> length definitions") added ETH_MODULE_SFF_8436_MAX_LEN for the overall
> size of the EEPROM info, so use that to report the full EEPROM contents.

For backporting in stable, a minimal fix this like is O.K.

For net-next, it would be better to implement the ethtool op
get_module_eeprom_by_page(). This takes all the logic for identifying
the SFP type out of the kernel driver, and allows user space to access
any page of any SFP.

See the Mellanox drive for an example.

    Andrew
