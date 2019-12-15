Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDD6F11FAFF
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 21:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726267AbfLOUPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 15:15:15 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39572 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfLOUPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 15:15:14 -0500
Received: by mail-pj1-f65.google.com with SMTP id v93so2038264pjb.6
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 12:15:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Z3+L3A/ZGbY/Yi9zSP83oRG6X3cCWxsLkT0EvKKhIv8=;
        b=eytfAPNskJmlyWkr2ZynREWJzmFeKK63gUSyjzLDtJ1tnm/59fuBu100TXAvqYqwuM
         1hocQujl1s0pp1Hrh/bhFYGZNrl8WPGWc1+l6cfmB/Dd/0fBuU8i2aJbx7VTEzsqF+R+
         e4W5cBZt1QMwpV8ANF2dgGxevhC/JgX3nV5gsV8dKebH/Uu2aLv9Zf8WJ5cNYBeW7zuB
         D1267nTNenAYteQmS31QhfPEeZ0TaxZOA/ZrUZMrP5olOehidOsaJH8YcRTbufRwxm/7
         1Y9DU6MXcvXfHSb3EbcxvJmZXnVV7w2tKLG2TesaKdHYqVwWbRnkOEVY3ZCIBEeFBpb7
         vxBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Z3+L3A/ZGbY/Yi9zSP83oRG6X3cCWxsLkT0EvKKhIv8=;
        b=X34Y8JrvlMHZ93JTk84iHB24wh/+fK+34eY0PCQ/KzA4HPSv/jhCi7EjTrCn/pfAKQ
         iTHGE5H+SpgVSAkTPTOy7+ohM/G17PqRRDKXqRRL1Py4QmtgsI0xMa5L2F75d3geDW/x
         PwiLc/eNf3qjawNeuB0U8scc4oPmvg3CnGSYUUfO49QcMzO9jo2GYZMeyJgaEMOXbFKj
         BYnkZYOgjiRxYT3Jbc2Bw1/V9TMJQToVuuj7QmRnPFMnl75VZm8hcrrKxV/qt5m5n/yb
         q6ajAVKc44s9G+4gpOfYqXQtcYJVxsrORPE6mHTHZeae09oPzDYdpwiHGfq2ZlCX2fl1
         am3Q==
X-Gm-Message-State: APjAAAUGRq242ZMYlwZrc4kwBqXEFO9TzCUFMqvJvt3tqMbKnDDAUm+o
        +yBx+URNeg73UhkXQt0UiTDLpQ==
X-Google-Smtp-Source: APXvYqxAk2U3jddeNGo6jRC+J+tajAWU7MbupF/UcgRUJd86TxfdMKwvt1HVEo1uaEP4YNIhDLYJgQ==
X-Received: by 2002:a17:902:7d84:: with SMTP id a4mr7029102plm.97.1576440914158;
        Sun, 15 Dec 2019 12:15:14 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id k1sm10280596pgq.70.2019.12.15.12.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 12:15:14 -0800 (PST)
Date:   Sun, 15 Dec 2019 12:15:10 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [PATCH net-next v2] tcp: Set rcv zerocopy hint correctly if skb
 last frag is < PAGE_SIZE
Message-ID: <20191215121510.25ad4353@cakuba.netronome.com>
In-Reply-To: <20191215195451.180553-1-edumazet@google.com>
References: <20191215195451.180553-1-edumazet@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 15 Dec 2019 11:54:51 -0800, Eric Dumazet wrote:
> From: Arjun Roy <arjunroy@google.com>
> 
> At present, if the last frag of paged data in a skb has < PAGE_SIZE
> data, we compute the recv_skip_hint as being equal to the size of that
> frag and the entire next skb.
> 
> Instead, just return the runt frag size as the hint.
> 
> recv_skip_hint is used by the application to skip over
> bytes that can not be mmaped, so returning a too big
> chunk is pessimistic and forces more bytes to be copied.
> 
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thank you!!
