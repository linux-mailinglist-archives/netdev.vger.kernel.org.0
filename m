Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E811413845F
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 02:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731844AbgALBAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 20:00:55 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:35992 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731838AbgALBAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 20:00:54 -0500
Received: by mail-pl1-f196.google.com with SMTP id a6so2371843plm.3;
        Sat, 11 Jan 2020 17:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=UzS8fCV70X00w/fY21xvJPaNUzV5IfL2EWyUuY3260o=;
        b=XcfvTIsa1Qk7wn7Ta9piJmi3d+Nb8RXnYMpKJzBH946VetaMUr218YE2tvynqGTLEl
         2PfLhr71rGoZtzmjKvUWmKgzb/uFzvmcNUTPZ+VZ1BBi0PKP96CzyPv/lT8TY5WSHDIy
         sBhS5zFFlISgAqtuSkyroFFqMQkp+rWhmMiOLCHFwYqiFx8RleWSba5wUW+KXPBFmsuY
         J+Ku5ZqNRVs/qjF1GhBkgUQQoq4I021aXuhcG402sf7vOHoiT7BcvlOqqMX5ewZjELX1
         ktMnnTeLqpb8DmAoY/hKThmAV+1y7HLFQphuOg7xo5YouFUGh2n9eDgH2fDS4CoDzs9z
         Kbsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=UzS8fCV70X00w/fY21xvJPaNUzV5IfL2EWyUuY3260o=;
        b=gSjOZevM4oBE6PJwmuMZfbN0TH/e0jfudG83EQxUI3a+HE2qKOuT6IRXBYC5yiJC+l
         6mrmJ9MsIUU94RzZ7XSRiYfEpZ0C0iCvVomRFykS+m1B483IsYdqPc7ogOXnIXE58q3n
         X+M/vf0slVsimfuicTsR99Zvff+/0F3/Kv8Ff4hvjBH73pyLzI603SyGeV2d5VXKjKbp
         1M3BBXClLA30gDuFzayaFvL68YX4G5P9Lin4x+yovn93dO3UDBiCy6o4CPtyIZdwdncN
         e9MKY41P50ezt+OqI/CxrYsCb50z4RKBH+YiU25cJimOS3yUWTX5MTpiy039xYIwYyel
         ee7g==
X-Gm-Message-State: APjAAAWs1isf+iG7rCGhpNM92LevYKBEDxiJy1f48LbpKuybS7ojWOea
        Pya90JjzOlUaSt+xoGJfkTq+p19S
X-Google-Smtp-Source: APXvYqxwW5RQn8w+xDSdQ5WEKQWPx2ZSuGVAdjXeM07GzXmMjvwggU6YubmhF2F1ikp1OzJ8yfXzWA==
X-Received: by 2002:a17:90b:30c8:: with SMTP id hi8mr14945876pjb.73.1578790854041;
        Sat, 11 Jan 2020 17:00:54 -0800 (PST)
Received: from [172.26.97.36] ([2620:10d:c090:180::694c])
        by smtp.gmail.com with ESMTPSA id r8sm7519368pjo.22.2020.01.11.17.00.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Jan 2020 17:00:53 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "John Fastabend" <john.fastabend@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, song@kernel.org
Subject: Re: [bpf PATCH v2 3/8] bpf: sockmap/tls, push write_space updates
 through ulp updates
Date:   Sat, 11 Jan 2020 17:00:52 -0800
X-Mailer: MailMate (1.13.1r5671)
Message-ID: <5D9DDCE5-DF7B-438A-ACCE-4CACC3141D87@gmail.com>
In-Reply-To: <20200111061206.8028-4-john.fastabend@gmail.com>
References: <20200111061206.8028-1-john.fastabend@gmail.com>
 <20200111061206.8028-4-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10 Jan 2020, at 22:12, John Fastabend wrote:

> When sockmap sock with TLS enabled is removed we cleanup bpf/psock state
> and call tcp_update_ulp() to push updates to TLS ULP on top. However, we
> don't push the write_space callback up and instead simply overwrite the
> op with the psock stored previous op. This may or may not be correct so
> to ensure we don't overwrite the TLS write space hook pass this field to
> the ULP and have it fixup the ctx.
>
> This completes a previous fix that pushed the ops through to the ULP
> but at the time missed doing this for write_space, presumably because
> write_space TLS hook was added around the same time.
>
> Cc: stable@vger.kernel.org
> Fixes: 95fa145479fbc ("bpf: sockmap/tls, close can race with map free")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
