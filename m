Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04222101744
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 07:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731698AbfKSF7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 00:59:13 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:45598 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730873AbfKSFr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 00:47:59 -0500
Received: by mail-il1-f194.google.com with SMTP id o18so18458361ils.12;
        Mon, 18 Nov 2019 21:47:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=IPbz9l190FdmmP/HIacCh9FEoAxpsKjWPjvXe684Hi8=;
        b=XHjzPY426lID6GEuEBPHFjTp/lisw9NDm0k1lmLR6G1YFopEh5wKt9cmkl3lstJUy5
         S32P0X9iVj9mpTQs+zB4Rd5Wee2mACD/+79dFlmwbfaHBgkbqrgSNa58zzms/nIbH7BB
         XDrT0DUJqFO8BAO4GWosLVMg2N+JdA4O72YpJhXot6i7xPjQiB0Ibi0WPeLqLEntMq1M
         qW3ENXNVvJQtyJrjMp3POrto4Y89ezTcTz0pHqsx0GrJxKZmQ/u+n8Pd3Zaee5Avlv5r
         70a/Czns9D1ZHY09tiDo605EEkytT9o9067hU5D8rE+jzEeVe97TA8dynz76C2UR362R
         5Azw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=IPbz9l190FdmmP/HIacCh9FEoAxpsKjWPjvXe684Hi8=;
        b=NsSUIvBGID2HP9Wt/FlYr3cbLVfO6Qf4VMJmdJDqp1WwovD7aZMmkfRfeINfTQ6nky
         YRgUKyVMcQW+9ue6tctZLP6Wn5/LwyQyxeYWhED9iwZrrH5UMtk43bWe4lNVAXcqnkat
         ITknwR6UPdFShCQ9Gv/xEmLOXCVlX7NLQl8vrpgU2A3BHDTNECxearzASSA89ZNa6d2d
         Q4vAGnxbLd05tNFsvns2w+KrpJgACSXDqVsmp9ABaj7cNVAxe73rowA+B/Ndc4EPkBhe
         XdzUaQlt1JJyXhQ7IPE996kyNTmcsBFmmH+jcDVJP3d+uIKCcSBaXa6LJhDcTzTvUcSh
         Gb6A==
X-Gm-Message-State: APjAAAVHWZsvreb1H1n810eruq2oO4MqFUDQWsxo75BMl6WmyQsl8glB
        LApm2+s8+dniQ3cbGYQ5xYA=
X-Google-Smtp-Source: APXvYqzX7QU2fknvTCLaROE5n/eN1zTPJpliVi7yGVgZU1K2YvZg2/ZGxiI0abhRTKOg+8K+zRv47g==
X-Received: by 2002:a92:6611:: with SMTP id a17mr19096397ilc.148.1574142478680;
        Mon, 18 Nov 2019 21:47:58 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z24sm4023653ioc.47.2019.11.18.21.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 21:47:58 -0800 (PST)
Date:   Mon, 18 Nov 2019 21:47:49 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, john.fastabend@gmail.com,
        jakub.kicinski@netronome.com, daniel@iogearbox.net,
        Willem de Bruijn <willemb@google.com>
Message-ID: <5dd38205959a5_613b2afc5fa285c4e6@john-XPS-13-9370.notmuch>
In-Reply-To: <20191118154051.242699-1-willemdebruijn.kernel@gmail.com>
References: <20191118154051.242699-1-willemdebruijn.kernel@gmail.com>
Subject: RE: [PATCH] net/tls: enable sk_msg redirect to tls socket egress
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Bring back tls_sw_sendpage_locked. sk_msg redirection into a socket
> with TLS_TX takes the following path:
> 
>   tcp_bpf_sendmsg_redir
>     tcp_bpf_push_locked
>       tcp_bpf_push
>         kernel_sendpage_locked
>           sock->ops->sendpage_locked
> 
> Also update the flags test in tls_sw_sendpage_locked to allow flag
> MSG_NO_SHARED_FRAGS. bpf_tcp_sendmsg sets this.
> 
> Link: https://lore.kernel.org/netdev/CA+FuTSdaAawmZ2N8nfDDKu3XLpXBbMtcCT0q4FntDD2gn8ASUw@mail.gmail.com/T/#t
> Link: https://github.com/wdebruij/kerneltools/commits/icept.2
> Fixes: 0608c69c9a80 ("bpf: sk_msg, sock{map|hash} redirect through ULP")
> Fixes: f3de19af0f5b ("Revert \"net/tls: remove unused function tls_sw_sendpage_locked\"")
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
