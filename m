Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8A7CCF66
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 10:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbfJFIWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 04:22:38 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49562 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbfJFIWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 04:22:38 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4B2EC609D1; Sun,  6 Oct 2019 08:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570350157;
        bh=SqieHTOXpZqhU6RhETvmGOUXAlCtg2LP3Jyt4v6rf0M=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=K7muK0k0+jHGbY6gbpJMiyKROHLTb3l/KChyf3Vr5qCrMSJdLyDSoRb4QlU/a1TAv
         Fdm4LO4IOkqsCdQEWbjKjACsvj44IwuWaMKMyzHrx7S7ubHL3htYXbHDBIPoYioknJ
         ZxL2Y+Ovy6qFU3DbCEQdSIGo/I9uJjSyBpo5x3QM=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from x230.qca.qualcomm.com (37-33-18-250.bb.dnainternet.fi [37.33.18.250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CFDEC601E7;
        Sun,  6 Oct 2019 08:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1570350156;
        bh=SqieHTOXpZqhU6RhETvmGOUXAlCtg2LP3Jyt4v6rf0M=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ly4vbG73eOFTxZ3qIpQUY7h4lzezSxESty2x4ukG0Bu0a0F+UwviFSp6I/+Ew3cxF
         SLKqB9ANMFMyRcfaUiB4Bmk82H8ynony7uQZKZAzrZmQnlHJ4qd+dbpzKWgW+HHqwJ
         O1sCcKWubN8EkSQYzA4wNaKoq6US95DJl8HW7hBI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CFDEC601E7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Denis Efremov <efremov@linux.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Subject: Re: [PATCH] rsi: fix potential null dereference in rsi_probe()
References: <20191002171811.23993-1-efremov@linux.com>
        <20191004134736.2D517619F4@smtp.codeaurora.org>
        <20191004144930.GC13531@localhost>
Date:   Sun, 06 Oct 2019 11:22:31 +0300
In-Reply-To: <20191004144930.GC13531@localhost> (Johan Hovold's message of
        "Fri, 4 Oct 2019 16:49:30 +0200")
Message-ID: <87eezqs2pk.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johan Hovold <johan@kernel.org> writes:

> On Fri, Oct 04, 2019 at 01:47:36PM +0000, Kalle Valo wrote:
>> Denis Efremov <efremov@linux.com> wrote:
>> 
>> > The id pointer can be NULL in rsi_probe().
>
> While the existing code in rsi_probe() may lead you to believe that,
> this statement is false. 
>
>> > It is checked everywhere except
>> > for the else branch in the idProduct condition. The patch adds NULL check
>> > before the id dereference in the rsi_dbg() call.
>> > 
>> > Fixes: 54fdb318c111 ("rsi: add new device model for 9116")
>> > Cc: Amitkumar Karwar <amitkarwar@gmail.com>
>> > Cc: Siva Rebbagondla <siva8118@gmail.com>
>> > Cc: Kalle Valo <kvalo@codeaurora.org>
>> > Signed-off-by: Denis Efremov <efremov@linux.com>
>> 
>> Patch applied to wireless-drivers-next.git, thanks.
>> 
>> f170d44bc4ec rsi: fix potential null dereference in rsi_probe()
>
> I just sent a revert to prevent the confusion from spreading (e.g. to
> stable autosel and contributers looking for things to work on). Hope you
> don't mind, Kalle.

That's great, thanks Johan.

-- 
Kalle Valo
