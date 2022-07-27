Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F150583204
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241718AbiG0S3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbiG0S3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:29:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C146C60519;
        Wed, 27 Jul 2022 10:27:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B983B821D9;
        Wed, 27 Jul 2022 17:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B573BC433C1;
        Wed, 27 Jul 2022 17:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658942844;
        bh=vClSK2mvCZQ5GtNM6iQVH5ucgKecXyuy7dqqAj7XCdQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GFRs41heO/Z7Amxlsa5ylML9UfcZ0MZbqE1MV+PBLegBddBu+6BPcjBw6EeIuT4n2
         WThm/ZLeHWqHzA5C7jOzaJugqSJXxKUicdXBuFSEECgAbz4cCEt/0UitT9ix0rB/2S
         +Z7bSVAwhxW07gnzynooadhFLNAOAwxMJ8KsJ0rfzrFMQzwDaEo8PT3HHXNS98kLBj
         1bCGfqUWCYPJzMnxoHH68AYsxJKGs7UhyuytFubyAUkWOyc1MB8ho5yFbXkGW/S4Dq
         aQk2he13vBhwVMA2cfq9Mx2TOTCvv342FN9rn1kLety6IEmKnqwoacyUpxJDhqcS+b
         HTXgQYUY8gxbw==
Date:   Wed, 27 Jul 2022 10:27:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hristo Venev <hristo@venev.name>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net v2] be2net: Fix uninitialized variable
Message-ID: <20220727102722.722e324f@kernel.org>
In-Reply-To: <20220726165454.123991-1-hristo@venev.name>
References: <20220722214205.5e384dbb@kernel.org>
        <20220726165454.123991-1-hristo@venev.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jul 2022 19:54:54 +0300 Hristo Venev wrote:
> The following error is reported by Smatch:
> 
>     drivers/net/ethernet/emulex/benet/be_ethtool.c:1392 be_get_module_eeprom()
>     error: uninitialized symbol 'status'.
> 
> When `eeprom->len == 0` and `eeprom->begin == PAGE_DATA_LEN`, we end
> up with neither of the pages being read, so `status` is left
> uninitialized.
> 
> While it appears that no caller will actually give `get_module_eeprom`
> a zero length, fixing this issue is trivial.

If there is no caller that can trigger this - it's not a fix. Fixes are
for bugs which can be triggered. Please repost against net-next without
the Fixes tag. Please don't post the v3 in reply to v2, just add a
changelog under the --- marker and make a fresh thread.

> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Fixes: d7241f679a59 ("be2net: Fix buffer overflow in be_get_module_eeprom")
> Signed-off-by: Hristo Venev <hristo@venev.name>
> ---
>  drivers/net/ethernet/emulex/benet/be_ethtool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
> index bd0df189d871..2145882d00cc 100644
> --- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
> +++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
> @@ -1361,7 +1361,7 @@ static int be_get_module_eeprom(struct net_device *netdev,
>  				struct ethtool_eeprom *eeprom, u8 *data)
>  {
>  	struct be_adapter *adapter = netdev_priv(netdev);
> -	int status;
> +	int status = 0;
>  	u32 begin, end;
>  
>  	if (!check_privilege(adapter, MAX_PRIVILEGES))

