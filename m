Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED39108052
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 21:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbfKWURO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 15:17:14 -0500
Received: from mail-pj1-f48.google.com ([209.85.216.48]:33912 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKWURO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 15:17:14 -0500
Received: by mail-pj1-f48.google.com with SMTP id bo14so4655816pjb.1
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 12:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=lkJTEvgeSeiw68+APuy3BU29ZQ9T44pMasailLQ33hU=;
        b=m1Oev6PiLkwyGXNN/gd7pvqKs2Bn/9q8OJy8Kc0x/GqVXK/bQsIhJgx6jn+po2/q8Q
         4G+YZv2MIF2FSKdubxD/YEciMQS0/m9LdwZNzrRMFzkzA7f+VbSnhNhbkzi2OIe1qE+l
         9loxsmTkY5HrWO0qOQRFQqGdCHpEO5l0nJZR6mWWWgIXsgsO6izsgBRSdKtM+p4nLHdf
         byPb2olUcvYxXooePNmYzigv6cVu1Xe+ucsNNwP6ZmNEa86304K6iQIoGdbQn+evvcqV
         mmJwWK7az0StiuDyrmW0uVJQgBUpFxZZ2eBsXSvc/2XnTJd88AXj2oxesUPHvCCEFBge
         iGqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=lkJTEvgeSeiw68+APuy3BU29ZQ9T44pMasailLQ33hU=;
        b=jXQVw0O8fjATGtuZuopj0Fca+QJbW58e6sGxHS4kOy4DL9hpEpPWs5cmVe8vRc9uOM
         lIYDTYDvZ9RkKbw31SV1d/7miMulSrOznFnGEAO1uUObbVuX2P5YchmffMxT3dlXW82F
         xA45LM7+ambKFmti72mDAQvEH+QKmLdkWjNtWOGFfKtzZ0jRwX60yOIQXWNkiWrETss5
         BvDZWUqpKAV7Ux2GZfnAWG16yMrpUDqSX+5T78sPHYgHeapOnA7+X1rVkimHKROKP/86
         HiUR8eiCb2WlVTnjlfmQBwaaey7Ldt/KqHB1tlMOkCsW0wXPQPobFzSK43FgwkR38pHF
         IWkg==
X-Gm-Message-State: APjAAAWNeKJj1idv0l/AgKg1NyhhJrMx+QcQ50UzzUKCIcO3hu2u6DJZ
        2rBl8zzG/HDcIvdJ956VGIH/yA==
X-Google-Smtp-Source: APXvYqyOsmN2CxwvHCpVCyFxm7hfy0SQLVFdcAR7x+2evDUQGoePhno3bP84BssA0BYnl2BZtaST4g==
X-Received: by 2002:a17:902:7448:: with SMTP id e8mr9577681plt.299.1574540233608;
        Sat, 23 Nov 2019 12:17:13 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id j7sm2769642pjz.12.2019.11.23.12.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 12:17:13 -0800 (PST)
Date:   Sat, 23 Nov 2019 12:17:08 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, saeedm@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: use rhashtable_lookup() instead of
 rhashtable_lookup_fast()
Message-ID: <20191123121708.3b459aef@cakuba.netronome.com>
In-Reply-To: <20191122081519.20918-1-ap420073@gmail.com>
References: <20191122081519.20918-1-ap420073@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 08:15:19 +0000, Taehee Yoo wrote:
> rhashtable_lookup_fast() internally calls rcu_read_lock() then,
> calls rhashtable_lookup(). So if rcu_read_lock() is already held,
> rhashtable_lookup() is enough.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Applied, thanks!
