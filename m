Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0812B7FE
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 17:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfE0O6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 10:58:42 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44182 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfE0O6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 10:58:42 -0400
Received: by mail-pl1-f195.google.com with SMTP id c5so7144515pll.11
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 07:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1HDorn020b95P5QjIbImPQwcjN3fb+vcklwL0uBNOB4=;
        b=dj+snbli8MeuVtvvWOX0i/MgbvyzGrxJcDF9vmnzSVKk7tykrUDOwHIe0eqGnKqEQF
         JcPGQ+qnbkHlQvwQeWdUR+LHeDyKaaPE3RFknEp5S1+TQORd4cEyFUq5EMm7dyzR4mFi
         upaD0ePc29TkvHC5B0c+5ygI+RdqlJNm5tjiPVLJF3vUf1EbGbSJ/HKf62lZMk34fsys
         MRfCsiCQF+GIlEGEJCP77ri459CbTyQ+FpWZvUXHa3syNXvzxorKjYWboz6cPuZZuNEj
         rA+DJ0hkB+h5/9Zkst1UTmXo06udSQ/RM9snSQXx7K/Xg4XmeC/cCd30X4X9/fjkm+Xk
         GByA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1HDorn020b95P5QjIbImPQwcjN3fb+vcklwL0uBNOB4=;
        b=BZeojAy+NzyQgNXf2fT2StyORjh69pM68lnB8/+5TkA21zTG/RS8/atDisCAw+udnw
         8Z1rFigQNGUY2fpcur+TY3Eugoj4EJlk5GqjGSL6Y/CrKmk/nJmvbbvjVH7Akwl0xycu
         DH1oayY/oow0+DMDAZdhGRTf668k3TPMjnEEcse1HKgkatLtGl/kZVxTGIi99LtOcdLs
         FElDbS43ErZMJwjMu9J32KEuxNCrb5bPXvhmLAUnKXS161gKPm02lTXg5h3HQmtD2DNK
         5R+1+7kwq1DkIjQemREj7mMbWLhbJvKt0qUnnzQ2Ri+h9mrlLQX3qbx636poOp/A2n/+
         7SJQ==
X-Gm-Message-State: APjAAAVR98+zCn4MZY1sM9Ee3nlzsUHWuYY6l0B+VsArfeviEafgSEtw
        E0iodWUruvnE26o+Dw5nk/l6Cw==
X-Google-Smtp-Source: APXvYqx7bkmiB37BGw4ZMiueOLTLzrpyuGwvCGpPwUQLdM5HBEpcaRkO1jmZENpeJmV1MMY5gGvmxw==
X-Received: by 2002:a17:902:9a43:: with SMTP id x3mr3162302plv.35.1558969121537;
        Mon, 27 May 2019 07:58:41 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id s12sm9701811pji.30.2019.05.27.07.58.41
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 May 2019 07:58:41 -0700 (PDT)
Date:   Mon, 27 May 2019 07:58:38 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <davem@davemloft.net>, <hkallweit1@gmail.com>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>
Subject: Re: [PATCH net-next] net: link_watch: prevent starvation when
 processing linkwatch wq
Message-ID: <20190527075838.5a65abf9@hermes.lan>
In-Reply-To: <1558921674-158349-1-git-send-email-linyunsheng@huawei.com>
References: <1558921674-158349-1-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 May 2019 09:47:54 +0800
Yunsheng Lin <linyunsheng@huawei.com> wrote:

> When user has configured a large number of virtual netdev, such
> as 4K vlans, the carrier on/off operation of the real netdev
> will also cause it's virtual netdev's link state to be processed
> in linkwatch. Currently, the processing is done in a work queue,
> which may cause worker starvation problem for other work queue.
> 
> This patch releases the cpu when link watch worker has processed
> a fixed number of netdev' link watch event, and schedule the
> work queue again when there is still link watch event remaining.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

Why not put link watch in its own workqueue so it is scheduled
separately from the system workqueue?
