Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A8CD1C86
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 01:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732292AbfJIXLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 19:11:54 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39097 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731916AbfJIXLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 19:11:54 -0400
Received: by mail-qk1-f196.google.com with SMTP id 4so3841028qki.6
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 16:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=9gky1upj5dA8lYUpQfO3Ma5Q6XwfSoS4nIQeV09aJYA=;
        b=KixzfUXlfD2HH7aQuQ7E1gHWg24BYmYxgzfl7FrV70rq2PWtm3IfacudraA7TU8a0k
         eQ7SYRGP+qshMwBByuLjuSsq4rRxj1uAcVdo6aG7bu2s0TcNhEuXGFdkVo6mlKu2MRv8
         Noot316CQ/ow5bhnvnh1QnbwuSVluXlzfjV5wZ90MYvsfaW+CLCYoCSpeB1K0bTYcmAu
         P0YXJxlKKVgH5j3ZsFK0xvrkBTisiJbP24MaOSSjCDVeUznMNNrDGGdWeBXJBXRjjpHY
         bWxAkR9U/WM5i2fhZHk1L9EaWcSs+46VPy0ARNq2aNIZWU+XpSMYaPMRN3If+THtnVUr
         /RQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=9gky1upj5dA8lYUpQfO3Ma5Q6XwfSoS4nIQeV09aJYA=;
        b=ELlneevh3bXX5iu70RewWu5k/gdLWz42ynHO7inYE9nK4GM5QOtqrm4ExyNnT6M9Ff
         Kt+iufkvfFONhVmkvyMUPzrzpWURXn6yLdQIL5nZ9DS0HMSMV14sXoyBFtZmNmO57gbR
         3FrDVcJPKg+3lUMnPyN8e83shakxiqqw9LsQGG27P/aS/JQt6ka2qfVN2ch7qJTUmhVC
         dB+31GX/7AMIOEb5JP+7ner8L1ChVjqWSgRdRNFK/VqLJ77h0WZnbKEOY0XJ5hSQyqfK
         tKseweOvLejq9gQRy58xl/xtmk5j3K0xWD+mK6rZPEwguGR2pzOPrTL6zQEy13WX5YwT
         ElbQ==
X-Gm-Message-State: APjAAAXnx7tPKGX47wKYWmvev9pPBCFY872QTCWR4SO/5Nk129WDv20l
        F3JPZMRaYGqcoLQMIdPAYziDLw==
X-Google-Smtp-Source: APXvYqyWbLET0B1S7J4CUuGoirJsY0pOpIrPkMPP4cn1+rYzADRDfE0cpZkuWLzoQpDg7p9vOiknsA==
X-Received: by 2002:a05:620a:1249:: with SMTP id a9mr6437435qkl.235.1570662713792;
        Wed, 09 Oct 2019 16:11:53 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j4sm1727816qkf.116.2019.10.09.16.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 16:11:53 -0700 (PDT)
Date:   Wed, 9 Oct 2019 16:11:39 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Mahesh Bandewar <maheshb@google.com>
Subject: Re: [PATCH net] bonding: fix potential NULL deref in
 bond_update_slave_arr
Message-ID: <20191009161139.24e2b49b@cakuba.netronome.com>
In-Reply-To: <20191007224301.218272-1-edumazet@google.com>
References: <20191007224301.218272-1-edumazet@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Oct 2019 15:43:01 -0700, Eric Dumazet wrote:
> syzbot got a NULL dereference in bond_update_slave_arr() [1],
> happening after a failure to allocate bond->slave_arr
> 
> A workqueue (bond_slave_arr_handler) is supposed to retry
> the allocation later, but if the slave is removed before
> the workqueue had a chance to complete, bond->slave_err
> can still be NULL.
> 
> [1]
> 
> [...]
> 
> Fixes: ee6377147409 ("bonding: Simplify the xmit function for modes that use xmit_hash")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Mahesh Bandewar <maheshb@google.com>

s/slave_err/slave_arr/

Applied, queued, thank you!
