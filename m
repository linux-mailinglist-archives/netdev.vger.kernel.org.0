Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1311103FD
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 19:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfLCSHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 13:07:14 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:46081 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfLCSHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 13:07:14 -0500
Received: by mail-pj1-f66.google.com with SMTP id z21so1804221pjq.13
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 10:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=/sxFBO+A4bmmlzeA7kuVL6WCWUyudTPsIA+QFiheH5M=;
        b=BAw/Dmnay1FLKQCIDZm7gksS5lhoF8Z8pN9rRw+7OMz3u6YDyu7z3zqsQPxKaUT5kQ
         HNyBORMDB003vrTmJ/ICK2nWe0X3SsrYlGRHuqmfAG0QDvTlw+lWuZhyWFExBGGiFbaj
         Em4mMOyfhrZj3nv3/oSol59HVfCLyDhAki2qhRoseCWCqaJwU/3P1bUAsq7UW0E1C6Y0
         ++PVI76pMnSdBJaQqS+19sszKnOCTSpuNPRcPvFpRlzscwFKE5BHiyFY4lygTOG3wL6k
         b16qMzks5zFEYvv8yQnkGojVS95Vm6a8zPGfTIh2kcVcMr/mfW0MkXJqxoBizSRIx+Tb
         ypmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/sxFBO+A4bmmlzeA7kuVL6WCWUyudTPsIA+QFiheH5M=;
        b=Y3iTPOEWj2Unp3DSc1ShH46CdmUJw5JxSE7IXi78A9LlW3amiPVmXZBhpRnoDgJyfZ
         oshlKoNXHfqc0ZqDT0k2fXr9wR95kGBAwdR/M/XmTWSNGWwZGV/E6Xaa7byFFdBI6izQ
         PzZ3qAw66L9DWvGBzKwWRYKbHrigFaAb8BtPz0kUFQTd/AAwIAe0kSf1DBCV9GW4iZcF
         4j9v2+G8xPn57wq/p7nnuee7tYdhm43tj+7n9CY9v8OjTgsNrjQ4UBSI5tBQ+Xpn0SJO
         INkl86bMGFnS3H10Qulrj1iDSwZzFk9ZZ+kAMi11OolLm2vbkq/emEEuw79eANeiZv9h
         c2FQ==
X-Gm-Message-State: APjAAAUkYZ6hMbtDpAUc5JbzPK+X8A8ntFAUAmlRRHgQYJAHcuoq2smt
        DzCmWfkkFZJtFfjZyfPszM+ZGg==
X-Google-Smtp-Source: APXvYqwg4cfBTLYScskl8BNpesAVZqxCCfCNlGvkZA2ZM13raINhG+LP2JI69AiqSD3T/ezOHPL4ig==
X-Received: by 2002:a17:902:8f96:: with SMTP id z22mr5932828plo.11.1575396433357;
        Tue, 03 Dec 2019 10:07:13 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id h6sm4103397pgq.61.2019.12.03.10.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 10:07:13 -0800 (PST)
Date:   Tue, 3 Dec 2019 10:07:01 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jcfaracco@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, dnmendes76@gmail.com
Subject: Re: [PATCH RFC v7 net-next] netdev: pass the stuck queue to the
 timeout handler
Message-ID: <20191203100701.0d6a367e@cakuba.netronome.com>
In-Reply-To: <20191203071101.427592-1-mst@redhat.com>
References: <20191203071101.427592-1-mst@redhat.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 3 Dec 2019 02:12:48 -0500, Michael S. Tsirkin wrote:
> This allows incrementing the correct timeout statistic without any mess.
> Down the road, devices can learn to reset just the specific queue.
> 
> The patch was generated with the following script:

Still:

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
