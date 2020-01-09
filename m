Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D73EA1363AA
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 00:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbgAIXLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 18:11:25 -0500
Received: from smtp8.emailarray.com ([65.39.216.67]:43933 "EHLO
        smtp8.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgAIXLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 18:11:25 -0500
Received: (qmail 29681 invoked by uid 89); 9 Jan 2020 23:04:43 -0000
Received: from unknown (HELO ?172.20.55.144?) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTk5LjIwMS42NC4xMzY=) (POLARISLOCAL)  
  by smtp8.emailarray.com with (AES256-GCM-SHA384 encrypted) SMTP; 9 Jan 2020 23:04:43 -0000
From:   "Jonathan Lemon" <jlemon@flugsvamp.com>
To:     "John Fastabend" <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [bpf PATCH 6/9] bpf: sockmap/tls, tls_sw can create a plaintext
 buf > encrypt buf
Date:   Thu, 09 Jan 2020 15:04:40 -0800
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <B265C993-B266-4CC7-B32A-C877667C545A@flugsvamp.com>
In-Reply-To: <157851813461.1732.9406594355094857662.stgit@ubuntu3-kvm2>
References: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2>
 <157851813461.1732.9406594355094857662.stgit@ubuntu3-kvm2>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8 Jan 2020, at 13:15, John Fastabend wrote:

> It is possible to build a plaintext buffer using push helper that is larger
> than the allocated encrypt buffer. When this record is pushed to crypto
> layers this can result in a NULL pointer dereference because the crypto
> API expects the encrypt buffer is large enough to fit the plaintext
> buffer.
>
> To resolve catch the cases this can happen and split the buffer into two
> records to send individually. Unfortunately, there is still one case to
> handle where the split creates a zero sized buffer. In this case we merge
> the buffers and unmark the split. This happens when apply is zero and user
> pushed data beyond encrypt buffer. This fixes the original case as well
> because the split allocated an encrypt buffer larger than the plaintext
> buffer and the merge simply moves the pointers around so we now have
> a reference to the new (larger) encrypt buffer.
>
> Perhaps its not ideal but it seems the best solution for a fixes branch
> and avoids handling these two cases, (a) apply that needs split and (b)
> non apply case. The are edge cases anyways so optimizing them seems not
> necessary unless someone wants later in next branches.
>
> Fixes: d3b18ad31f93d ("tls: add bpf support to sk_msg handling")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
