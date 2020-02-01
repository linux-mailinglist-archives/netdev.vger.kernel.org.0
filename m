Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05EFA14FA2A
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 20:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgBATWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 14:22:08 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:44370 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgBATWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 14:22:08 -0500
Received: by mail-oi1-f196.google.com with SMTP id d62so10754935oia.11
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 11:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q+/4BRPdDC4OHdpoYzkno5Hb99b4VoJnNv6Pj6hOGSs=;
        b=LIiQGMos8mV2sYNUM2MMkiBiRqXB++iQ6QbnPifixSSDTXecYmacEtG2n/+casFNln
         7fuXZ18+CI8Xo9LfwyhMDHiO5o7ghP0M7f2bwfNFBdRMiw6M9cy+6Cxms1XoDfaS8oax
         cIdA64QoXR6OMOLsrnwm9IU6QFdZILmB+bE4bWlVouvwEeBWWtMBAALrZpjjral5PsIH
         RpDrmwi/A6fRmQZ0zd03TlHmzWI1CwV5zDi0LIjzc1MPO1Us/tVJRL044sRnrCuWkund
         KviazC54UTXKhMMSeC3H8b9csul26dAuE0vYBT4RR1CqbmwXOnFqnyM2Yg6U6GRI0iDa
         x4Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q+/4BRPdDC4OHdpoYzkno5Hb99b4VoJnNv6Pj6hOGSs=;
        b=gR6dxlqqxJOjOS349xj+puqFUzZEUTS8VrU+S7xwX7QlKrZ0qYsXOf2jdxj9vrteDU
         1cTrEV1WOV2Xk+j+VlnCFbyNn+UT8AWYaViTY7miFGFvC+UXk956OjqDN8DtJdzwHC2z
         WveAw/Ygv3G3qdFav6LXqKnq3cOtkSFjfOdnlQP9VGKcRQ65YNZVHPx6JHy/9xvoW3Dq
         KJcKxPvZXN4bMJ1wbLX5thzNvvUCXhs4WQFj87rWEsf8+X0mKM2lUk72qFubATyv2CVf
         asoYrpYDYOFKNpryv95fXOHgsdTaH0dgBjrnz9347nN0/pf6UvZq3Sbl+kyapoLIEP3n
         wszw==
X-Gm-Message-State: APjAAAVaTxkvXsDaDmvrcLpf+9uk0SdkPyP8FkgSiVwE5T9ubUmVgaBb
        eX8RPFR+Ksxdg6moPmEIHyPUtYNO4clzhR5iWIU=
X-Google-Smtp-Source: APXvYqwlfE8QWdAqrT7gb6xtEYgCAGDRTyvFHzhkrDfI5XXGeynJOfc01R0KIL4S7XFJoCvLJmljMdcd8V1c9urkY6s=
X-Received: by 2002:aca:f08:: with SMTP id 8mr10437481oip.60.1580584927213;
 Sat, 01 Feb 2020 11:22:07 -0800 (PST)
MIME-Version: 1.0
References: <20200131232704.161648-1-edumazet@google.com>
In-Reply-To: <20200131232704.161648-1-edumazet@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 1 Feb 2020 11:21:55 -0800
Message-ID: <CAM_iQpUYOLkZu9hn9+_XbMDTY5Q0aOq6qLrDt9PD0zh8kNPw1A@mail.gmail.com>
Subject: Re: [PATCH net] cls_rsvp: fix rsvp_policy
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 3:27 PM 'Eric Dumazet' via syzkaller
<syzkaller@googlegroups.com> wrote:
>
> NLA_BINARY can be confusing, since .len value represents
> the max size of the blob.
>
> cls_rsvp really wants user space to provide long enough data
> for TCA_RSVP_DST and TCA_RSVP_SRC attributes.

To clarify: for NLA_UNSPEC (0), len is the minimum length.

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
