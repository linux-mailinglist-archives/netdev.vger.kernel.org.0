Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08AC2A2A86
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbfH2XGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:06:35 -0400
Received: from mail-ed1-f45.google.com ([209.85.208.45]:40310 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbfH2XGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 19:06:35 -0400
Received: by mail-ed1-f45.google.com with SMTP id h8so5855077edv.7
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 16:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=FtL/6UIvNooJf6BcUuT3J05y4WGBC+SYQNLYYW+z1lE=;
        b=sjTXafcnmhgo+I9Fon7EyOQ7lwKuSTbjSRgFlBOrUd8ZSDX2R2B4kCZfW0tc0mbdNu
         5sX6iZawTbEVKL7IyolNXa+eysKrMlEImtfA1R56MchRVlBPMxMzsoAudsJrdNu/fENF
         /9EQ3IPuCfZVGE6UhlevscRAX/Y5flTnWvq6Ffd5AuaPCGAiY8tspDzRj9DZ7Bl7xHQd
         CLuSY0xd0MkgE4/Cn8vqkcwSaIvigYvA+UP2/Os0qNEmC70prMag+vpKlCjcU6kINJ9U
         2+7pLYhSyvHQhATe4J6r9sHa+Y25/deD8LBCraw8AMxGuWEIaSxMMEDzOct9FFbwMgoy
         Sn5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=FtL/6UIvNooJf6BcUuT3J05y4WGBC+SYQNLYYW+z1lE=;
        b=KLH4gsYcKwmGB31OPpt9lGH+lDmybphVJBXG7pPx6wiFXHHylqB1G/wb4Q9gSx5Hp8
         M4A/L4AeBUGtJt23RJk2GSC2mghBC2fG4AHkJ3h+wMT6bRDJotGReoKSu3imBi0AmGET
         yG2YNMHjMbT0otd4EbdCNFgiDTOliNTeWwrmw7WDgDTHk2Ruc1PVNf0KmaLnV6cBNJkI
         LEwNgdGub0/AQ92HbRDwUAFSFKISIfFXYL5/qJ5XmC469fdA1916+Y7JGR6iyymszSAh
         ZWJtzAfA9MuAB9WWOuQi1SzABI0TM+NVv5M23jYKB2l5MjSjmxKHhm+vQ98y8XxKUg+I
         Twaw==
X-Gm-Message-State: APjAAAUNG4UgUSC2FAsewtRHOzYyFYTqFSwMlcGqaKJuvwxUDi56XCsE
        dWQmm/OOn3nbnmr1PcgDGciitg==
X-Google-Smtp-Source: APXvYqyPpRjouyppeDoNcHXxs0RAbCRYtelqZ9B7XL+Yp4/blGkr8Rzqi/A7RLIJLvQL3MmiBdG1/A==
X-Received: by 2002:a50:9f27:: with SMTP id b36mr12600080edf.64.1567119993666;
        Thu, 29 Aug 2019 16:06:33 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m6sm550064eja.53.2019.08.29.16.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 16:06:33 -0700 (PDT)
Date:   Thu, 29 Aug 2019 16:06:10 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH v6 net-next 12/19] ionic: Add Rx filter and rx_mode ndo
 support
Message-ID: <20190829160610.60563ca0@cakuba.netronome.com>
In-Reply-To: <20190829182720.68419-13-snelson@pensando.io>
References: <20190829182720.68419-1-snelson@pensando.io>
        <20190829182720.68419-13-snelson@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 11:27:13 -0700, Shannon Nelson wrote:
> @@ -588,8 +866,26 @@ static int ionic_set_features(struct net_device *netdev,
>  
>  static int ionic_set_mac_address(struct net_device *netdev, void *sa)
>  {
> -	netdev_info(netdev, "%s: stubbed\n", __func__);
> -	return 0;
> +	struct sockaddr *addr = sa;
> +	u8 *mac;
> +
> +	mac = (u8 *)addr->sa_data;
> +	if (ether_addr_equal(netdev->dev_addr, mac))
> +		return 0;
> +
> +	if (!is_valid_ether_addr(mac))
> +		return -EADDRNOTAVAIL;
> +
> +	if (!is_zero_ether_addr(netdev->dev_addr)) {
> +		netdev_info(netdev, "deleting mac addr %pM\n",
> +			    netdev->dev_addr);
> +		ionic_addr_del(netdev, netdev->dev_addr);
> +	}
> +
> +	memcpy(netdev->dev_addr, mac, netdev->addr_len);
> +	netdev_info(netdev, "updating mac addr %pM\n", mac);
> +
> +	return ionic_addr_add(netdev, mac);
>  }

Please use the eth_prepare_mac_addr_change() and
eth_commit_mac_addr_change() helpers.
