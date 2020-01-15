Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A69513CCE1
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 20:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgAOTKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 14:10:38 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:55646 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbgAOTKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 14:10:38 -0500
Received: by mail-pj1-f65.google.com with SMTP id d5so340197pjz.5;
        Wed, 15 Jan 2020 11:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=e7qnWTjXKtYLUrT4kaSeZ4w09gtUQFgA7WBlukts/Ko=;
        b=uxxFl4ODXq26iZkfGkBzZbsE/rTTHHC16s8lWPfAb+At5e/06w9+AL9wTcW0lANsRU
         81Vdqvxfs0Z/J5fzBXpb+kS8GwoAAL53ox9+Pg+5lV1ZYAdBjWgkvnYP3kufCaIKFXxe
         80bSoRvxLWNQp9K0Bqf8slK6z6R9eqEDQHPbgR7TaIqAP+qimbtba0OmpyNls2NxD0B4
         MBLUzCe7TvxH7aj5wX6b8m7VlzmbVBfKB4HZ7EDDZU4+KGQ7OWk77Q0J1k63x2EIxM6/
         nIOI2vxQfyOWj8aa8ZwS3KATBnMdNzRoRYMPf8nLk95aifhzWqUmql+me4ereinEfPyV
         6y7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=e7qnWTjXKtYLUrT4kaSeZ4w09gtUQFgA7WBlukts/Ko=;
        b=BrON/XLlmw3soDeupqUntkmCRcFSgVvu6/Frdq/WIGF2x+qMdjxZ+G+vVT3xxaaKUj
         pddSIXF5mkUArQ7bA+xRtTDBalWZhNzMz2tcZ52tY6imIHv0CAVDo3d5B4CM5wNa8Ef0
         lZfGbbvyTClNRymPjeUGiJ0NP1LwvHmFZ8QvvGlazOux763ly6eDBBvlUzgwfJQ9ibB7
         NioUV4CD8+bMuStg+4BBW71I0ljzeTyHxROGXQj+iO7GqnmZykS3XIH7xy8vpUp4cqno
         ew+tlqknNI2FHjvOQFu7a6+y8XeDBAk5jw3Z2HholIzc4O+I6mOny1GMWMWfMceurhRU
         kAZQ==
X-Gm-Message-State: APjAAAUKwLpTZZ9OV9REP/YynJPbur2qZXNfKNc1bxt2tOy/i7vN3S5p
        A0Nwu0YB8ulFzNtj4gFxVMg=
X-Google-Smtp-Source: APXvYqwam+yFrqjlfk3yx89b9ArSGd1jbkXmJxH+5jbdYi+Z+/xH4rEBVIkgRzbPgMfozaaE+CUTgg==
X-Received: by 2002:a17:90a:5206:: with SMTP id v6mr1626610pjh.136.1579115437483;
        Wed, 15 Jan 2020 11:10:37 -0800 (PST)
Received: from [172.26.104.66] ([2620:10d:c090:180::ce50])
        by smtp.gmail.com with ESMTPSA id x7sm23341936pfp.93.2020.01.15.11.10.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Jan 2020 11:10:36 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Magnus Karlsson" <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, rgoodfel@isi.edu, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] xsk: support allocations of large umems
Date:   Wed, 15 Jan 2020 11:10:35 -0800
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <F5A36D1D-633C-4CDB-A49D-71DE73E26963@gmail.com>
In-Reply-To: <1578995365-7050-1-git-send-email-magnus.karlsson@intel.com>
References: <1578995365-7050-1-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14 Jan 2020, at 1:49, Magnus Karlsson wrote:

> When registering a umem area that is sufficiently large (>1G on an
> x86), kmalloc cannot be used to allocate one of the internal data
> structures, as the size requested gets too large. Use kvmalloc instead
> that falls back on vmalloc if the allocation is too large for kmalloc.
>
> Also add accounting for this structure as it is triggered by a user
> space action (the XDP_UMEM_REG setsockopt) and it is by far the
> largest structure of kernel allocated memory in xsk.
>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Reported-by: Ryan Goodfellow <rgoodfel@isi.edu>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
