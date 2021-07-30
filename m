Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0813DB998
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 15:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238990AbhG3Nt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 09:49:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231137AbhG3Nt2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 09:49:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4497160E76;
        Fri, 30 Jul 2021 13:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627652963;
        bh=cjyn1FQlgULSs6XOeucG41KDKpvDgok3AqwrydFEJ2U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SUaOcX5+vXK+N2TAySbwzC2loMfkHgtJWmXNx/9t1JpCFKMxwwZ6MS3cpkxRQue6+
         c2KrhE9w+pqX9JMhm5Ed0BBxl7mQpWhoE0GregUiQDtQ0mpMJavfjXC/CaT8mRQiIK
         CVbrgTx+VfgXnSq0Xj603iPpptb0selFZ5noyCh7tEX104Ykb9u3KqJfDq/I4hOsjC
         Dj7gU0xjKTBw7pC79IMCOXXAg1Cd3WPZ5X/Ce1Pukeq07JI2Emm5h7hRGlW/hIA1ry
         09QvKRsxLw2cDBYPaMh9ETa38X8PVssDh7p22zgaSIvAPJ/gX7wRLBLKowEvvr/Ds7
         HoT+PyviC+xuQ==
Date:   Fri, 30 Jul 2021 06:49:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/8] nfc: hci: pass callback data param as pointer in
 nci_request()
Message-ID: <20210730064922.078bd222@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210730065625.34010-8-krzysztof.kozlowski@canonical.com>
References: <20210730065625.34010-1-krzysztof.kozlowski@canonical.com>
        <20210730065625.34010-8-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Jul 2021 08:56:24 +0200 Krzysztof Kozlowski wrote:
> The nci_request() receives a callback function and unsigned long data
> argument "opt" which is passed to the callback.  Almost all of the
> nci_request() callers pass pointer to a stack variable as data argument.
> Only few pass scalar value (e.g. u8).
> 
> All such callbacks do not modify passed data argument and in previous
> commit they were made as const.  However passing pointers via unsigned
> long removes the const annotation.  The callback could simply cast
> unsigned long to a pointer to writeable memory.
> 
> Use "const void *" as type of this "opt" argument to solve this and
> prevent modifying the pointed contents.  This is also consistent with
> generic pattern of passing data arguments - via "void *".  In few places
> passing scalar values, use casts via "unsigned long" to suppress any
> warnings.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

This generates a bunch of warnings:

net/nfc/nci/core.c:381:51: warning: Using plain integer as NULL pointer
net/nfc/nci/core.c:388:50: warning: Using plain integer as NULL pointer
net/nfc/nci/core.c:494:57: warning: Using plain integer as NULL pointer
net/nfc/nci/core.c:520:65: warning: Using plain integer as NULL pointer
net/nfc/nci/core.c:570:44: warning: Using plain integer as NULL pointer
net/nfc/nci/core.c:815:34: warning: Using plain integer as NULL pointer
net/nfc/nci/core.c:856:50: warning: Using plain integer as NULL pointer

BTW applying this set will resolve the warnings introduced by applying
"part 2" out of order, right? No further action needed?
