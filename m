Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8C3E26DB
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 01:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407880AbfJWXDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 19:03:51 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:42492 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733196AbfJWXDv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 19:03:51 -0400
Received: by mail-pg1-f193.google.com with SMTP id f14so12992297pgi.9;
        Wed, 23 Oct 2019 16:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=/OHxiXD2KyXURICS7ZLFhn4YJcbAYHn2yp+8MzAvfDc=;
        b=spC33OlITWelnU7Z8JWyAbqDTQvQywvirjEaDIyHeT0QVWGLczOmCa5xCp0DVwywjR
         msJY8gY9kornpUrkl+cVGEcIBGhjTh/jxUT1E6d9A1L87mxVBMYrbgYD80Tzy/0u8nHY
         3icB+hu4GJobS22XqmGng/Ewvrz+tRltrbQS4y015GxTjShJVbBxpboZZwxsLLsqYhwM
         YTxtbgYWBE7OuslRYPmPkbcYIiWHZPANhBMbw3je3CWJH18AvwZJAlNBnMsarje6COYw
         Zo/n9cWmYRPom3E3jeZmTUBKk0u2UGzNuXKNaUJNwrYYfZdEizz9qzui1uv0RMo9lrts
         O30A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=/OHxiXD2KyXURICS7ZLFhn4YJcbAYHn2yp+8MzAvfDc=;
        b=JKNGeEUv+W7wlRPXfh4366uwwbwxULcgbneH5E0CEUi4AKAXQHW8VH4R7+/9i0aIv6
         Y35ap/WcmxK6uJKXzCRthMVJxfa0NL9tgbOCxJ/Sks4BDY6Vj+0a4IaVJaA1f32YXSs4
         fvkWqb0G//Cxw/CaKSBARdGOeTT/nmYXDMS6/gjbz+lr4KQbqFp47OMBr0E10qNNnzxy
         5EbeThKuZFa2tWLuwIP7CnmmMZDywLOD7bpP/d9ZscQ+YKCdx9vnyJtssCn0VvgvJ9oG
         36izUo7u1eK2LJ2UnLBHkFFZ5Vdry3rGV+f5WftFLJnbbxl7hUMY24wbEizg5Fy7N9Ue
         5qvw==
X-Gm-Message-State: APjAAAXwr2N7MBiqKu92zG+AzNPHwi0uA0LtgiH23TJNcfy0lHi373BB
        QqtdzwxcUvo1p6X0Uqr9CzE=
X-Google-Smtp-Source: APXvYqy7Jps/4WrxQ+4F846S7kPT3OEJ2c0PSYVG+Y1beL2fC2dtGNo/1v5tyXd/G8GbepPoYvyWKA==
X-Received: by 2002:a63:2326:: with SMTP id j38mr12500963pgj.283.1571871830405;
        Wed, 23 Oct 2019 16:03:50 -0700 (PDT)
Received: from [172.26.117.3] ([2620:10d:c090:180::cbd8])
        by smtp.gmail.com with ESMTPSA id w2sm19272129pgm.18.2019.10.23.16.03.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 16:03:49 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Magnus Karlsson" <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, kal.conley@dectris.com, bpf@vger.kernel.org
Subject: Re: [PATCH bpf] xsk: fix registration of Rx-only sockets
Date:   Wed, 23 Oct 2019 16:03:48 -0700
X-Mailer: MailMate (1.13r5655)
Message-ID: <B551C016-76AE-46D3-B2F5-15AFF9073735@gmail.com>
In-Reply-To: <1571645818-16244-1-git-send-email-magnus.karlsson@intel.com>
References: <1571645818-16244-1-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21 Oct 2019, at 1:16, Magnus Karlsson wrote:

> Having Rx-only AF_XDP sockets can potentially lead to a crash in the
> system by a NULL pointer dereference in xsk_umem_consume_tx(). This
> function iterates through a list of all sockets tied to a umem and
> checks if there are any packets to send on the Tx ring. Rx-only
> sockets do not have a Tx ring, so this will cause a NULL pointer
> dereference. This will happen if you have registered one or more
> Rx-only sockets to a umem and the driver is checking the Tx ring even
> on Rx, or if the XDP_SHARED_UMEM mode is used and there is a mix of
> Rx-only and other sockets tied to the same umem.
>
> Fixed by only putting sockets with a Tx component on the list that
> xsk_umem_consume_tx() iterates over.

A future improvement might be renaming umem->xsk_list to umem->xsk_tx_list
or similar, in order to make it clear that the list is only used on the
TX path.

>
> Fixes: ac98d8aab61b ("xsk: wire upp Tx zero-copy functions")
> Reported-by: Kal Cutter Conley <kal.conley@dectris.com>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>

-- 
Jonathan
