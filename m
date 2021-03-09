Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E333332F09
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 20:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhCITcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 14:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbhCITb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 14:31:59 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E66C06174A;
        Tue,  9 Mar 2021 11:31:58 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id x29so9481567pgk.6;
        Tue, 09 Mar 2021 11:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HYJycecCKR8mJEVeAV0bVwc2FaxFgSqtKDz5fqSfG+Y=;
        b=t/BAtgEgV5Af5sZNLuhwg2mdyygRwGzvxfza2L1PSTQ6joDvwFqZ8lbBB+By+CVx8/
         dUqnPxqvWKnjVW+DAQdeYYddYwnXCiTXS+gRCOmwf50ydHtFaTTdJSkJD3cC8ydC+Gze
         Ykg6oQQ7UEKaTY1Bm86L0+LFwWHnybFhTlmYqONyfIEtKyCV6u8kt68Mwh4PN6hryHfv
         NyQsnZZCaGGMKf0/7tNfVmSnhHbiz2lRUO3BDw0/PhNNZxZAHj6hp/Aq6/Plhk3db8xN
         RpYtQCQNgk7c14Z5nBq9fA0iRHVwjHJJxGrZ80Ymthrn9iohWPWdp4y+MEVbfYTNqJLN
         U2JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HYJycecCKR8mJEVeAV0bVwc2FaxFgSqtKDz5fqSfG+Y=;
        b=qvZXzdIu79PJh9Xo1Qe4MBs0aGFYE+4+WBDTrQdi+AILoQ+Uz4dlTzOOsNVrQmSExa
         BYH+wfVrLgSJVGeyyggHCoT1JUBU4XJ37xdRkfXhOJgxEJAzdim6ym9EFHRcUHNnmK15
         piqHCZXHpceeVYI2a4Z249w7UWlJcgS8pZhwPeeSAlKAIp5Ql8oQtzQ+cef9vYx99MKl
         xBBr91ZW34FzKv1sg2bM3dZTHrRvKCzpPyufBGhb8hxmQjJQSAzBY2rAbDHTJi+UAWxr
         250s/NXiIWWJEIURO2zYPMZHbS8166z01O26tEpQzrxW2V1R5n3cYXNAWNJ3jKt/lQzB
         4o0A==
X-Gm-Message-State: AOAM533479CFV0bxqnTvFNAJhdQxny9/dM9T8zRXyK0jYQVNWyNAoRYp
        CyvGndso2WhA5JFSi6AXyo8iKymQTJq78A7cb30NuNcz
X-Google-Smtp-Source: ABdhPJzlxVuyzwg/hJK8di9C/jil7B+Ti5mXNWdgDFd2l3Eiy/MUpPBDNiI39hYbF+32J3EexKNxVsayZLBJIl66iA0=
X-Received: by 2002:a63:fb4d:: with SMTP id w13mr26864300pgj.233.1615318318606;
 Tue, 09 Mar 2021 11:31:58 -0800 (PST)
MIME-Version: 1.0
References: <20210305054312.254922-1-xie.he.0141@gmail.com> <4b30ca506b0d79ef5ba1a5e9ce9cf2cd@dev.tdt.de>
In-Reply-To: <4b30ca506b0d79ef5ba1a5e9ce9cf2cd@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 9 Mar 2021 11:31:47 -0800
Message-ID: <CAJht_EM7Wtmtwi4=vEybSNbQrNmugC7HCLYcAjM07gEgeRtHMA@mail.gmail.com>
Subject: Re: [PATCH net-next RFC] net: x25: Queue received packets in the
 drivers instead of per-CPU queues
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 9, 2021 at 5:23 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> I've tested the hdlc_x25 driver.
> Looks good to me.
>
> Acked-by: Martin Schiller <ms@dev.tdt.de>

Thank you!!

I'll re-send this patch after net-next is re-opened and my other fixes
get merged into net-next.

Thanks!
