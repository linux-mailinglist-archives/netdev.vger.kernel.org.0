Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA39162FAE
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 20:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgBRTWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 14:22:21 -0500
Received: from mail-ua1-f54.google.com ([209.85.222.54]:36665 "EHLO
        mail-ua1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgBRTWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 14:22:21 -0500
Received: by mail-ua1-f54.google.com with SMTP id y3so7894271uae.3
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 11:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=YbgargU8ALt/nB7SKZ47CKsWwNRksvqKNRcpqJ5pJaY=;
        b=iAWf/tw2BDerSn7IxVh7DdIyqHNZThH47QVhqCprUX2FjBe98WfKWxYmLCM6hAK4lG
         Mv/ivouhM0N8uXYsVzYq3gNN9/Y+h7biM1Cp6q5MYZ0epevol/ckM16/N5UF4nikOqRt
         9cEdgKuUh0oSDhEcy2y3PxJP/aGl2GxLR9T6WSAwRimuT+MejWGnhNcgFCAtv5jO6JqJ
         51pLPmaw6lKyfG9K+EU24dn9xsNT5bwE/E0sB3nWWA1IkB+/iZhY9WAVKs93ZLv+iLXr
         1gqPtog72DtbEjjbOulUuiEK8qlkmZG3jhEtaz5XyHLWuZgPEq5r14zPQ7PigrLoCgwf
         zpoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=YbgargU8ALt/nB7SKZ47CKsWwNRksvqKNRcpqJ5pJaY=;
        b=L3+Ve60rbHC+Xz4jEubsBWrPbfd1alPy2lhGxVKtLqYQUq9kYOuv0bbcepujD68ANC
         pxOfzoplDVA6mqIjVne9VowlqyepmAjFHMNm4PhMPF4ssI6DKQFwbG5a/ExFVPOtfgGq
         J9waQ63w5ya+rmhzdYHAKvaO0iUqmstFt9AMnk1N1mh6wZdNUvWXcW/3x+Ld6RvuHW0v
         /uvSkW3Z3EJG+TVAhhzsRpIRhP/xN7C+3vTpp2MowM7iwULeUlXwwP2PNtQ+lMp/BwxW
         Ce9iD/g4BRns9DCcKvVAs1Z2N22tazdrXLbvYWm4di46QhCyRAunWZxsIZnb7tTmyv4m
         tZLw==
X-Gm-Message-State: APjAAAXXJ8yVTMfEhLh2WafEQF8USaBJPqm8gdoNWr+lJK28ZPwwFIDC
        MQexHc0tyFCr2ccbpti2dPq+v6hw10D7btM2Q4Athw==
X-Google-Smtp-Source: APXvYqw2d0k0qU/8FLKEr1vWMuMMgdu6g1QEpcd2i3V4OHL3uLOS4FN2aoNXyazEgugYUPlN+EZAiFtXBS9c/u3GeJY=
X-Received: by 2002:a9f:2808:: with SMTP id c8mr11274756uac.49.1582053740074;
 Tue, 18 Feb 2020 11:22:20 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ab0:4186:0:0:0:0:0 with HTTP; Tue, 18 Feb 2020 11:22:19
 -0800 (PST)
From:   Kent Dorfman <kent.dorfman766@gmail.com>
Date:   Tue, 18 Feb 2020 14:22:19 -0500
Message-ID: <CAK4PFCVewY-n0Z=q8NeQCaV+p1PWL9-eQg+j5+7RD3mtks+rNA@mail.gmail.com>
Subject: need to identify sl# interface used by a particular instance of
 slattach (not subscribed to LKML)
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey gents.

As is usually the case, engineering decisions were made before I came
on-board, and now I'm stuck dealing with plans that I had no input
into.

Anyway, company advertised to external customers that they could
connect their widgets to our system using plain ole uncompressed SLIP
over RS422 serial (four wire, no flow control, 115200bps)

Problem, as you may have guessed, is that since the lines are
statically allocated I need to be able to assign static IPs based on
the tty port they are using.  I haven't used a SLIP dialup since
mid-90s and from what I remember, the sl# link is dynamically
allocated based on the "next available" when the slattach command
handshakes with the other end.  This leaves me without knowing what
sl# interface to assign the IP number to.  The common use case was
always a single sl link over a dialup line, not 16+ different
statically allocated slip connections on a single server (with no end
user authentication to define the IP on a per-port basis)

What is my work-around?  How can I know which sl interface to
configure based on a particular tty serial link?

I'm not a LKML subscriber, so please CC me directly.
