Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692E754FAA2
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 17:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235728AbiFQPpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 11:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbiFQPpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 11:45:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1ADF46B11
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 08:45:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EEF8612F0
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 15:45:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A08C3411B;
        Fri, 17 Jun 2022 15:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655480736;
        bh=Kon5jWAWwaHTXDijYp3p7SL42MIc9HWCRdW5N43fMIk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CIiSMUNnAelEyASra5UsJty3XDpNrzvr5FRvHYVkwUx8Z9/tTOCUo0dVSDOcSxuxY
         41dJV4FwqJwb7kvbB6UetWr7034COvjsh9LqoHf5I7Bd9Z7xAGcgvRvz2+l/itQqcm
         mJw/A7EtjJ7R+nVsioZYeytq4VJzbHj7ftkfNRkd+cezDRNtuVNw7dKR5CBclqycAR
         kMAlfZA72BibCazWuJGGYenk4WWWjSNy/jUG3Zf0/OCxorvraa+xjL2mD5523ymy/k
         Iwb74QB+qWqCtOTDOXwmzQpFg58IpY0SBCOKiqfqWH/HsiG08VKkrDqDU6zHt6f0hW
         Mi1voVatYGKEA==
Date:   Fri, 17 Jun 2022 08:45:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jonathan Toppins <jtoppins@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net] veth: Add updating of trans_start
Message-ID: <20220617084535.6d687ed0@kernel.org>
In-Reply-To: <9088.1655407590@famine>
References: <9088.1655407590@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jun 2022 12:26:30 -0700 Jay Vosburgh wrote:
> 	Since commit 21a75f0915dd ("bonding: Fix ARP monitor validation"),
> the bonding ARP / ND link monitors depend on the trans_start time to
> determine link availability.  NETIF_F_LLTX drivers must update trans_start
> directly, which veth does not do.  This prevents use of the ARP or ND link
> monitors with veth interfaces in a bond.

Why is a SW device required to update its trans_start? trans_start is
for the Tx hang watchdog, AFAIK, not a general use attribute. There's
plenty of NETIF_F_LLTX devices, are they all broken? 
