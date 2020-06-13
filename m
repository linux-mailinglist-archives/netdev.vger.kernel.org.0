Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB291F85B0
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 00:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgFMWgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 18:36:17 -0400
Received: from smtp.uniroma2.it ([160.80.6.16]:41795 "EHLO smtp.uniroma2.it"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgFMWgQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Jun 2020 18:36:16 -0400
Received: from smtpauth-2019-1.uniroma2.it (smtpauth.uniroma2.it [160.80.5.46])
        by smtp-2015.uniroma2.it (8.14.4/8.14.4/Debian-8) with ESMTP id 05DMZxuG019259;
        Sun, 14 Jun 2020 00:36:04 +0200
Received: from lubuntu-18.04 (unknown [160.80.103.126])
        by smtpauth-2019-1.uniroma2.it (Postfix) with ESMTPSA id 7B69212093E;
        Sun, 14 Jun 2020 00:35:54 +0200 (CEST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=uniroma2.it;
        s=ed201904; t=1592087755; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MsxSNSWu5WD8jMh67/fRBqZEczfqOOR6ef+YVsRr9WY=;
        b=VPAcboqRmMNleJACcpdM1QYqhnF4kvR/lSDmChodPo4fFw3MR0kWNgM7z1Bu/rOPJG8y7c
        dUwiVb7ALY7aE+DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniroma2.it; s=rsa201904;
        t=1592087755; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MsxSNSWu5WD8jMh67/fRBqZEczfqOOR6ef+YVsRr9WY=;
        b=ean5dyqRTvryl0C/DnYRYjcPoqJodQHoy2hlrjz7bwF/ymZa3W9SVBQPG5LRTOQMNuInPe
        lzD6eqH+JSh9rObufD3lr0mEwivDUupUzkKEkRBWkE+kuOB0uY6xSVM7ntgXAs6Ng4yQmi
        QltbM95WeAnT2AHhK/yi3w1TtPSXY2I7HpkL1IVnWIjgBV12I9CUbfKDuJKf/RpqWLRa8o
        7xl7MOxwyMxOFzUNKibFffD16Fa435/RgVT8x3aESR/k6EApD1k/2F19Z8Yf9EsylleYwB
        bQXElNccPltGiCPtLVhOu91asE8hRSgPBi402xKqtIJhGc+t/vFjB+84Bp5B6w==
Date:   Sun, 14 Jun 2020 00:35:54 +0200
From:   Andrea Mayer <andrea.mayer@uniroma2.it>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Donald Sharp <sharpd@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Dinesh Dutt <didutt@gmail.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels@gmail.com>
Subject: Re: [RFC,net-next, 1/5] l3mdev: add infrastructure for table to VRF
 mapping
Message-Id: <20200614003554.4bfed8a61a5741bfd2660d30@uniroma2.it>
In-Reply-To: <20200612105148.1b977dc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200612164937.5468-1-andrea.mayer@uniroma2.it>
        <20200612164937.5468-2-andrea.mayer@uniroma2.it>
        <20200612105148.1b977dc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.0 at smtp-2015
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Jun 2020 10:51:48 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> net/l3mdev/l3mdev.c:12:1: warning: symbol 'l3mdev_lock' was not declared. Should it be static?
> 
> Please make sure it doesn't add errors with W=1 C=1 :)

Hi Jakub,
thanks for your feedback.

sorry, I did not want to add more warnings! I will declare the l3mdev_lock
static! I will be more careful while checking with W=1 and C=1 next time.

Thanks,
Andrea
