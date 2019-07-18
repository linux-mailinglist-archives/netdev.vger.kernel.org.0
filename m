Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1296D603
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 22:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbfGRUvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 16:51:05 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37151 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727687AbfGRUvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 16:51:05 -0400
Received: by mail-lj1-f193.google.com with SMTP id z28so28757267ljn.4;
        Thu, 18 Jul 2019 13:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HDu13UtrMifuP4ieVUNMrgFuVWiJDZKmA3L25mnUVVg=;
        b=XrHxrMGiCGggpGHIjkvaFA+3HrF6NeGKV2uZHOpuCj2LaR9yupO7vk7FSnt7iK2x3v
         L+s6ketN8SJ6706Dmlnly8TLBl36ehAV77RJbtsA/I/ZbwFq92ctkvb7+xNLtfmpjz+X
         Ednh2hH9+ghljWokPvagcepmoV9jcrD2VFYetfXxF7iZXojKl5gmDlwqAWJdwJ2LvBl0
         1KLnKIXQBWLG+0eRg47R6qoeYGfAH8O9g2koqhzfNYBkn8bZwpCV9pHveKvHt9RZ1fzC
         KE0jQwiTlw6LoPC5FREJgx1XPLhr6tAPlMNyFon1iFkFHhvn3Vlec79DwnFjcpU4SDdK
         AcNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HDu13UtrMifuP4ieVUNMrgFuVWiJDZKmA3L25mnUVVg=;
        b=aya5XgMSaVLjRUeT3f9lIQECde5vAyVCiRmf6LSWV0GdxF7ZWJUQGdS41APRKEmGYf
         x3xr5jjpQwMXWycbTJvivgzI+sjksOzB/F0GHbymDFfzeL5ciBiWMFmgk7fnZJVwSJbU
         yAFm0xV3KDCH+hblCt1shND80s1Zq00xAy6E5KXyLFBPbHlCKP9HIb7NfKAsBP6FAeQz
         UH3wFY6msZoJl7BjZH4OoITlBh+X9UwKbyLx8dQVP50zadpCdmixxq6gOuHzmdEoJ01g
         602DeoCcQMvIJEPR6kMhVxR6XkJMIRvwU13KExFXY5DQ9DxlmR79Yq+5KzIypznjelpc
         1/XQ==
X-Gm-Message-State: APjAAAXUxtU1vms0bXo6vKYIdBuRvjU6uXiyCJW11ScOIUjda314dTrS
        dPEULmKOOlTKVBXs7tQUT9POmLKu1nKxJSmOzZo=
X-Google-Smtp-Source: APXvYqzfxBLofZGg2b65penh7QQklpQTP+YdgIyX43YZN1eMfPzSGrBhhwF86VvndH/on6iVtPHctxoDlgvATEMqMoM=
X-Received: by 2002:a2e:9e81:: with SMTP id f1mr25654772ljk.29.1563483062889;
 Thu, 18 Jul 2019 13:51:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190718091335.73695-1-iii@linux.ibm.com>
In-Reply-To: <20190718091335.73695-1-iii@linux.ibm.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 18 Jul 2019 13:50:51 -0700
Message-ID: <CAADnVQJChzh-tb2NqEb584YKBePhVDik__ssAKWfojs9GAVQzg@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: fix "valid read map access into a
 read-only array 1" on s390
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        gor@linux.ibm.com, Heiko Carstens <heiko.carstens@de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 2:14 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> This test looks up a 32-bit map element and then loads it using a 64-bit
> load. This does not work on s390, which is a big-endian machine.
>
> Since the point of this test doesn't seem to be loading a smaller value
> using a larger load, simply use a 32-bit load.
>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>

Applied. Thanks
