Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 369414C2FE9
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 16:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236428AbiBXPgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 10:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234926AbiBXPf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 10:35:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712E720A94A;
        Thu, 24 Feb 2022 07:35:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23B74B826DF;
        Thu, 24 Feb 2022 15:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CE1C340E9;
        Thu, 24 Feb 2022 15:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645716925;
        bh=xuHQRrAoDb/VVH82gAa2RaQTr5wBd7B/nPTDQnPfdTk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=jmlK609LeDES/o7jfPCY/auDpAUs+Tc5Q0iM0KqAn76wD/ETKzdD+VxSyMxgEzBEX
         i8xzFfC0v6WaDQLnzo6qHnTsh1qIN+y2Y5zVO9hxce3vCjik8SwECIReyYd5xTocsv
         muI57CDMEo5VV/BlEQbFFjSwmPP/zpmtekcwAgLSjtdLXYqXFgpxC9D4XX6TBEQiBB
         ZLLsx2HbZVZrs86vz1wvchVFO3lK521PHlFxZ6iaUwpCX0Aqs6gXr9ddmUtl4GqyAF
         xxw9yhcR8bwdcmm+Xtx264X9pVdieR9y2/12jvpgMHUW25f4W/6PGYN+gifEc34y4S
         8aytQtbn3hgog==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/2] wireless: Initial driver submission for pureLiFi STA
 devices
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20211031131122.275386-3-srini.raju@purelifi.com>
References: <20211031131122.275386-3-srini.raju@purelifi.com>
To:     Srinivasan Raju <srini.raju@purelifi.com>
Cc:     mostafa.afgani@purelifi.com,
        Srinivasan Raju <srini.raju@purelifi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org (open list),
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164571691946.20059.3084416025465167444.kvalo@kernel.org>
Date:   Thu, 24 Feb 2022 15:35:23 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Srinivasan Raju <srini.raju@purelifi.com> wrote:

> This driver implementation has been based on the zd1211rw driver
> 
> Driver is based on 802.11 softMAC Architecture and uses
> native 802.11 for configuration and management
> 
> The driver is compiled and tested in ARM, x86 architectures and
> compiled in powerpc architecture
> 
> Signed-off-by: Srinivasan Raju <srini.raju@purelifi.com>

I was about to take this to wireless-next but found few issues still:

o rename these to include plfxlc_ prefix:

int download_fpga(struct usb_interface *intf)
int download_xl_firmware(struct usb_interface *intf)
int plf_usb_wreq(void *buffer, int buffer_len,
void tx_urb_complete(struct urb *urb)
struct firmware_file {
#define urb_dev(urb) (&(urb)->dev->dev)
int plf_usb_wreq_async(struct plfxlc_usb *usb, const u8 *buffer,
int plf_usb_wreq(void *buffer, int buffer_len,

* non-const global variable in usb.c, doesn't that prevent supporting multiple
  devices on the same host? It should be stored into a dynamically allocated
  location like struct plfxlc_usb.

struct usb_interface *ez_usb_interface;

* unused workqueue:

static struct workqueue_struct *plfxlc_workqueue;

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20211031131122.275386-3-srini.raju@purelifi.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

