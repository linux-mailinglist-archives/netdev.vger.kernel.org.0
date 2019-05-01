Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A26B10449
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 05:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbfEADgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 23:36:51 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43216 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfEADgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 23:36:50 -0400
Received: by mail-qt1-f195.google.com with SMTP id g4so18838623qtq.10;
        Tue, 30 Apr 2019 20:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=R5deZxCLxpuHEvDkoegtFWu+sXv1DafnkERbG4Y4Tzc=;
        b=veOkV91RGDtIrswaFdymxRHtZ64Zbs0LVNFtdD+4qDXjy4p/iKOsQTyVW3tuyVxSu/
         x9yFxVqbir8SJrt+Zq0hQ52j7KxW4fy1Jg59hl4XMrIT3qw28ClRehx9PaUtnTi1vwxq
         RlqMVDpm9arGubyu8ItzJZZa6z0qGy5j5fAeEjxgYL4BQ8ZpM8BuGidITKE01eGZ6yzx
         dVk8Nl6kGdQE1OjjbxrNAhtlJp9mooY9e00QVfId0c9eXarQQwipqrDKtkzcuhscDrsa
         1eC3Hmxovbi88nMTmu1LoREMny3Lwkiu7myab/WeQE6b/ErDLah5ZnO6Slp4jQWbY/F0
         lRew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=R5deZxCLxpuHEvDkoegtFWu+sXv1DafnkERbG4Y4Tzc=;
        b=KQojByExQ/OpWiJG8hqLWcEcjgawAbqyKNZ5IjPzudx5iFSQXwqZ4mXo+/9RYIIqgj
         BvZmV3biWEAIBi4OfCzzz+D5DvTFj5Ec5xwbT+tZX3GV69IURq+HbTOvw5RGTlyD0hcI
         uZ2igAO/26nrSCveoBEF3Sl0MANRzhlyh41bsZiQGZR0sZ2uf9XUutYDI2GZPsNV9shs
         TgK+VpwpNfoM5tO5CIM7J442vSLkpw6sZQJVoRR7pvPKFgUCr8QqjN4/DAqOjnStAsEk
         mzO+8xB+wt7Dyq3b+suTpUG7+JkklM6N0HCcUJr+9Qp/tQ3Td9jgyHtefG0wrc4nIz85
         2Yow==
X-Gm-Message-State: APjAAAX3HKOxHskof7FiKX8EeZ5esjWACgfiaQ8NtCI8O68Meh+3pPM3
        5xJ0HJSZRFmhfyKK3VumD0OPZhAZotNUwtpvSbHX8NVkrBY=
X-Google-Smtp-Source: APXvYqxXjzpS/jmB7+7fX5wSr+p/7GiVxCQYGYVDOu6ls7/dRAvqBuvCxsyf7t6sY8qbFDbhXmCFxKkboQDTeadWWT4=
X-Received: by 2002:ac8:3f67:: with SMTP id w36mr42773317qtk.73.1556681809657;
 Tue, 30 Apr 2019 20:36:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190430124536.7734-1-bjorn.topel@gmail.com> <20190430124536.7734-2-bjorn.topel@gmail.com>
In-Reply-To: <20190430124536.7734-2-bjorn.topel@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Tue, 30 Apr 2019 20:36:13 -0700
Message-ID: <CALDO+SZbD7rXj1rPdZui5OByp-6RXADQpkzq5vXcaqLEK+YuQQ@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] libbpf: fix invalid munmap call
To:     bpf@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 5:46 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> When unmapping the AF_XDP memory regions used for the rings, an
> invalid address was passed to the munmap() calls. Instead of passing
> the beginning of the memory region, the descriptor region was passed
> to munmap.
>
> When the userspace application tried to tear down an AF_XDP socket,
> the operation failed and the application would still have a reference
> to socket it wished to get rid of.
>
> Reported-by: William Tu <u9012063@gmail.com>
> Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
Thank you.
Tested-by: William Tu <u9012063@gmail.com>
