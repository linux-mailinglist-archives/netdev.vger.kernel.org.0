Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8DD9A080
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 21:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731509AbfHVTvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 15:51:42 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38450 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbfHVTvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 15:51:41 -0400
Received: by mail-pf1-f193.google.com with SMTP id o70so4667273pfg.5;
        Thu, 22 Aug 2019 12:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=Kfl18FpM/XAci4fHCuqG5GPCb1xU4xeI3MoyLakSpmI=;
        b=QwSk8rYGAWusM2Ur/kdh+3lGkQwQc33PuQ2ZLVioWVgsO5Fj6YP5S1ssOZjh4fWZQV
         dgV5aAV5j0YsxclQ4IMpNTT9LZNn96HnO0pgoTgfrLjD5RDaOL4N91glHTWd4X5D4sTw
         gi5Omlr30DNnuALjeHAPFLBlr3sPv84dQm0WD1o7lOObDNfhlf5MPLBG7S+2keG6Z7Ul
         jnBC4AoPoN0Lmb4qmaBH+jMFStDsUiO27CVpEltazretehfxC1zdD8ziBa+fX+P+aGqw
         0kQWwOK0Vqt841aGYfDaMGItr5RFyAN+Licn26PZI3ex3Y9aLIvnWtBTy18T1i809pF5
         S+cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Kfl18FpM/XAci4fHCuqG5GPCb1xU4xeI3MoyLakSpmI=;
        b=C/s/QZYoQA2P561PWHmmDVNdN0fIVlPzXADn9S+Z3acj3rHXpgjEEvnBqmSxSDWiQB
         8eaSM0dlT8EF8WpDIpw0pOsWk4FlvTY4vKUAlasAXUE/oTpYCtW9v5zSYBsKmm201VVt
         8/4cBJH4VYj4Y4kO0TUE0o6P2TeYMxRqfTwYUgg8BvKhmNRreTbKjNJWqWM8mQj2p7+1
         NXwGvjXqAPdj2Tk3PvjpWXKau8GT/iAbE+dzpDH7WQ/aL/Ftz0iXGodfLxpWI4aQp/jC
         C8RPrvgBQuIx6eYX1PTtDxWjuEeb5nty9o8qtmjSJigmw8c37lNJ3Acp3JjsH0KIstJO
         3CyQ==
X-Gm-Message-State: APjAAAWsJN9JIRy6sQ2PVzFOzjL/YCFL89jUwORXk9RxrgWFnOdJkBfH
        bgkKBYABWgA32OSNKglN6qkXtgzy
X-Google-Smtp-Source: APXvYqyOa4BrAVFLBd5/tHmGIOLZcipQZxeBvdtSxMf7KF2x3o0bEVoP1LXxr+5Jax6aIHJj2nYZLA==
X-Received: by 2002:a62:642:: with SMTP id 63mr920630pfg.257.1566503500972;
        Thu, 22 Aug 2019 12:51:40 -0700 (PDT)
Received: from bharath12345-Inspiron-5559 ([103.110.42.34])
        by smtp.gmail.com with ESMTPSA id q3sm209993pfn.4.2019.08.22.12.51.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Aug 2019 12:51:40 -0700 (PDT)
Date:   Fri, 23 Aug 2019 01:21:33 +0530
From:   Bharath Vedartham <linux.bhar@gmail.com>
To:     davem@davemloft.net, gregkh@linuxfoundation.org,
        allison@lohutok.net
Cc:     tglx@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: net/dst_cache.c: preemption bug in net/dst_cache.c
Message-ID: <20190822195132.GA2100@bharath12345-Inspiron-5559>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I just want to bring attention to the syzbot bug [1]

Even though syzbot claims the bug to be in net/tipc, I feel it is in
net/dst_cache.c. Please correct me if I am wrong.

This bug is being triggered a lot of times by syzbot since the day it
was reported. Also given that this is core networking code, I felt it
was important to bring this to attention.

It looks like preemption needs to be disabled before using this_cpu_ptr
or maybe we would be better of using a get_cpu_var and put_cpu_var combo
here.

[1] https://syzkaller.appspot.com/bug?id=dc6352b92862eb79373fe03fdf9af5928753e057

Thank you
Bharath
