Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E35EDE0D9
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 00:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfJTWQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 18:16:23 -0400
Received: from mail-oi1-f173.google.com ([209.85.167.173]:35598 "EHLO
        mail-oi1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbfJTWQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 18:16:23 -0400
Received: by mail-oi1-f173.google.com with SMTP id x3so9479923oig.2
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 15:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2NFiplO/duAewYKVneQcQQGylDAPK2bukYpl4K78Dsc=;
        b=bQWHpaKdy43onS6BoyLvH1TouTdm8Fs88SGnWaJlia2m9/5TVW1OU8NgCJJwIowmnc
         NK2+1F3vUOge9C9ShavpN71u82rblqodLUvg+4f8FUZpz8aKRTRrfjoLm4WFEYvHzfFa
         qoHqESv+gtKjG1uLbHlDHMfD/VGRI54PiRrG4pXBzj60S2zhtr81qi1+Z/dqx3uwJ4yE
         S2kc8hkmGvBBA0WhhZYo5tWNVAqNTZCxcrO+5D22i0SDGIrCk7I2ZjKK3X6c1r694YF8
         RbG/c64fQfmIy4mDqYfoOtu5jgvS8T6G6OKTdKb7rhA7noPUjBNKBNE5GE1a24PnnwwL
         KpoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2NFiplO/duAewYKVneQcQQGylDAPK2bukYpl4K78Dsc=;
        b=E8Ho2lcKPujppIP5ouG99AFF1qBeMxMd+ykpqImWdurfGJzJi9vQoKwR6Xd87NQrC+
         jYbg/sWHxDKa8Wdox6IbcqnpY72XKFyIXUK+cKLfoFC/FcbKXg0Y6hq6Hj+1fvyE6LMA
         EguJPIciGUkmIlfUwGrOON+RVXSOLVRRbM94xoSgx6ZNVFq/h7qYuSe6Jq6bUReSvFeB
         Ku0uZhgtDPdDGKlf53TdD1yN4rrLt95wY0r6HSFwRIKLaJpHJ6VFl8AKYKPU50QSZUtf
         P67F8V++95L2+tnsjFklCJ+Y8NbougODq7wioD7e43nH33tWpJrawYwpCGGyXGl9rBVz
         J3fg==
X-Gm-Message-State: APjAAAU4/SYV0c1S4nb7KPLlgu8atxxbbJjpeAhnXnXjpWIgaY7ug03C
        3TUcKvfh6+UMVu+h6962dE2W9EFlpgk6Pwrde8nFDg==
X-Google-Smtp-Source: APXvYqzu/Y6WT6CGBjKEFMoo1P0SgKDtvLR931XkUDMoAIyj5mwURExpmvSEle3hn3k6Bah4XtheTF+whvbCjbHSGDY=
X-Received: by 2002:aca:4d12:: with SMTP id a18mr15871158oib.79.1571609781660;
 Sun, 20 Oct 2019 15:16:21 -0700 (PDT)
MIME-Version: 1.0
References: <68ad6fb82c0edfb788c7ce1a3bdc851b@codeaurora.org>
In-Reply-To: <68ad6fb82c0edfb788c7ce1a3bdc851b@codeaurora.org>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Sun, 20 Oct 2019 18:16:04 -0400
Message-ID: <CADVnQynFeJCpv4irANd8O63ck0ewUq66EDSHHRKdv-zieGZ+UA@mail.gmail.com>
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     Netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_write_queue_purgeOn Sun, Oct 20, 2019 at 4:25 PM Subash Abhinov
Kasiviswanathan <subashab@codeaurora.org> wrote:
>
> We are seeing a crash in the TCP ACK codepath often in our regression
> racks with an ARM64 device with 4.19 based kernel.
>
> It appears that the tp->highest_ack is invalid when being accessed when
> a
> FIN-ACK is received. In all the instances of the crash, the tcp socket
> is in TCP_FIN_WAIT1 state.

Hmm. Random related thought while searching for a possible cause: I
wonder if tcp_write_queue_purge() should clear tp->highest_sack (and
possibly tp->sacked_out)? The tcp_write_queue_purge() code is careful
to call  tcp_clear_all_retrans_hints(tcp_sk(sk)) and I would imagine
that similar considerations would imply that we should clear at least
tp->highest_sack?

neal
