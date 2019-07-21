Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3876A6F69A
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 01:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbfGUXIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 19:08:39 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57228 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726167AbfGUXIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jul 2019 19:08:39 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id B939E8EE105;
        Sun, 21 Jul 2019 16:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1563750517;
        bh=mpQW7FGrJB7rmR1nmV6m3V1GTNaPj3kOjzaz4eZp9Ik=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LXq+BCz0OH1gGgj+Rhft0XdRqxEfX2FaeFnT1pHQ2bf7CxwcU4cr2eL8EXJiWNXLA
         kbNsNOw9XAedh+luDytBF6AuIrpu9WPPsADVpNAtGET5UCEVHyJIL5jvtGeM+GL7Nk
         eua2uxWau1zmvY9tZr5Va38lNqgpX3Ayk9RdcNbE=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id qOBa1RhLoC6V; Sun, 21 Jul 2019 16:08:37 -0700 (PDT)
Received: from [192.168.12.43] (unknown [153.171.18.229])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id F368E8EE104;
        Sun, 21 Jul 2019 16:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1563750517;
        bh=mpQW7FGrJB7rmR1nmV6m3V1GTNaPj3kOjzaz4eZp9Ik=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LXq+BCz0OH1gGgj+Rhft0XdRqxEfX2FaeFnT1pHQ2bf7CxwcU4cr2eL8EXJiWNXLA
         kbNsNOw9XAedh+luDytBF6AuIrpu9WPPsADVpNAtGET5UCEVHyJIL5jvtGeM+GL7Nk
         eua2uxWau1zmvY9tZr5Va38lNqgpX3Ayk9RdcNbE=
Message-ID: <1563750513.2898.4.camel@HansenPartnership.com>
Subject: Re: [PATCH] unaligned: delete 1-byte accessors
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Alexey Dobriyan <adobriyan@gmail.com>, akpm@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        axboe@kernel.dk, kvalo@codeaurora.org, john.johansen@canonical.com,
        linux-arch@vger.kernel.org
Date:   Mon, 22 Jul 2019 08:08:33 +0900
In-Reply-To: <20190721215253.GA18177@avx2>
References: <20190721215253.GA18177@avx2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-07-22 at 00:52 +0300, Alexey Dobriyan wrote:
> Each and every 1-byte access is aligned!

The design idea of this is for parsing descriptors.  We simply chunk up
the describing structure using get_unaligned for everything.  The
reason is because a lot of these structures come with reserved areas
which we may make use of later.  If we're using get_unaligned for
everything we can simply change a u8 to a u16 in the structure
absorbing the reserved padding.  With your change now I'd have to chase
down every byte access and replace it with get_unaligned instead of
simply changing the structure.

What's the significant advantage of this change that compensates for
the problems the above causes?

James

