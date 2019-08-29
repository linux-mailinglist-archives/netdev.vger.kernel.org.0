Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8A8A22D0
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 19:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbfH2RxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 13:53:04 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38532 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbfH2RxE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 13:53:04 -0400
Received: by mail-ed1-f67.google.com with SMTP id r12so4997394edo.5
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 10:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=rQe28KLlHDvRerbTckpdwu9z06KjBNQSCvgEdw6K0Eg=;
        b=tT4DAN9gN76+WHbhh4TG+YpgAKU/LKtZGbtUHvgNZpZPWwwxb3Pwgp9gY7KmU56bpy
         Xv1Oq1K0lQufSYgylVI+058laygeoiV6N89ge00rHLiXwHGiNADSAFMw+IREzVPLdmbm
         29QRSeWyqEjtFKzgmU/Oh4LEis0bpqKyTEXryAK2+G74ogQAz2rvUVehVUUgTm3guAGR
         tc0wT9c1rWjzmZScMBFDvQx8095V+I/Peg6OfokDBFRF8hCJTN3fBKPdwPvp0YW3qq/0
         OTHoEIVl0PKVOAilqTaxbMVHTpX3mKVBd8whSWyym6Whg2ycKCFrqVDXraFG8/Rltggo
         Dqsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=rQe28KLlHDvRerbTckpdwu9z06KjBNQSCvgEdw6K0Eg=;
        b=MP5FiaOUiNWWaU05T28LqAMetyFaxxz0jw4TNxzYWgh7chuCOgKYTjYvMuFa6bIbgX
         go/p/xQjqVcS6HSz7OFhMv+19g+Ehj9SNoyoOTj8b8I5KTGMzd/PkWyWCZNatNVXoZ+g
         j/nejfWZ2OwQxkUymehKOCNTdFPKLqs/aXFgliyKnW6OzmcBzV5GVVuI/T3+Gz+hIZxa
         M0SI4Ww5aj2W2LZQPNHYAET6CVA25m/S9pbVCzlf9VEB/RsfOhWeb8J5c/yUPdW/FfTx
         g/hOZmNwgxLqLAQZNo4rfucCiPutxIxY8WldIg8wHo3c8nTscIzs9ujYaUrf9X3VWKQW
         cXFQ==
X-Gm-Message-State: APjAAAUzkyaQoPDLCbGkwsqDSwxGI0U88IQCcR3ADmkODuUqWCpZ64WF
        dudhH0Jglb8QwizuNvSLyYj2OuZD3zs=
X-Google-Smtp-Source: APXvYqxnC2uMVrjennbToNj8VdCMI+ckmVLgKgzd1CJo3FT41fg7GQyb9+ZSHDwMlxZVGV+MZnKiFQ==
X-Received: by 2002:a50:b155:: with SMTP id l21mr11232219edd.186.1567101182497;
        Thu, 29 Aug 2019 10:53:02 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id w3sm562294edq.12.2019.08.29.10.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 10:53:02 -0700 (PDT)
Date:   Thu, 29 Aug 2019 10:52:37 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <thomas.lendacky@amd.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd-xgbe: Fix error path in xgbe_mod_init()
Message-ID: <20190829105237.196722f9@cakuba.netronome.com>
In-Reply-To: <20190829024600.16052-1-yuehaibing@huawei.com>
References: <20190829024600.16052-1-yuehaibing@huawei.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 10:46:00 +0800, YueHaibing wrote:
> In xgbe_mod_init(), we should do cleanup if some error occurs
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Fixes: efbaa828330a ("amd-xgbe: Add support to handle device renaming")
> Fixes: 47f164deab22 ("amd-xgbe: Add PCI device support")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Looks correct.

For networking fixes please try to use [PATCH net] as a tag ([PATCH
net-next] for normal, non-fix patches).
