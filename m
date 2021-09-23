Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47387415762
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 06:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239050AbhIWEXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 00:23:34 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:36509 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhIWEXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 00:23:30 -0400
Received: by mail-wr1-f44.google.com with SMTP id g16so13238364wrb.3;
        Wed, 22 Sep 2021 21:21:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lz+dbdxsH1ZK2pJhZeOXoDpDI3RmHY4duyLP2ZtdPes=;
        b=niROZRJZblJAKdI37jP2F2K37/sABAL9P2ptilWWr2Eb9o/B/0PyRJUswriK4MnMWu
         ecK9Q/+naf4fjAeNvJkGQ8gw+8UeRS8HSSBRQ8mBCBSMW9IVNF0Fvys9wkM2hXBC27fm
         VNVKn6rEr5qWM0FPXRDDeCMiUU336Y7hgHpdtZb3PIZSDWTzRKvzY/9vpU23XatoAizm
         R1SYrEIk2vp7boHs81qjN63AsDSVYRsCUNyPpq3u1f1R4IBnbw8a6/Dx8iWKwj3J72ZL
         X9i1wSGsNcnNEZ/iNFOLU663qjjx0sqoTSChEjluDqwW8x6cKaLFKtmiK7n7SYC++lKN
         JhjA==
X-Gm-Message-State: AOAM530Nn/yUuoOyu9CL6qSfHnnN1e5w1qOAFkP9vVZCpnsW4EzLgXiQ
        COtqjacZzLx6G2PneGVB/yrR+sAlrU1zew==
X-Google-Smtp-Source: ABdhPJz2YNKJT1U4yPmQDRoWT5cGQdrgZF6UEz/a9GlZwZUP4EthrMuQMXmFEee07caR0m4083vX1w==
X-Received: by 2002:adf:f789:: with SMTP id q9mr2497783wrp.367.1632370918780;
        Wed, 22 Sep 2021 21:21:58 -0700 (PDT)
Received: from rocinante ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id f19sm3765545wmf.11.2021.09.22.21.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 21:21:58 -0700 (PDT)
Date:   Thu, 23 Sep 2021 06:21:57 +0200
From:   Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     helgaas@kernel.org, hch@infradead.org, logang@deltatee.com,
        leon@kernel.org, linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V9 4/8] PCI/sysfs: Add a 10-Bit Tag sysfs file PCIe
 Endpoint devices
Message-ID: <YUwA5eC7wiDoHy0F@rocinante>
References: <20210922133655.51811-1-liudongdong3@huawei.com>
 <20210922133655.51811-5-liudongdong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210922133655.51811-5-liudongdong3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thank you for sending the patch over!  A few small comments below.

[...]
> +static ssize_t pci_10bit_tag_store(struct device *dev,
> +				   struct device_attribute *attr,
> +				   const char *buf, size_t count)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	bool enable;

Would you mind adding the following capabilities check here?

	if (!capable(CAP_SYS_ADMIN))
		return -EPERM;

This is so we make sure that whatever user is going to use this sysfs
attribute actually has enough permissions to update this value safely.

> +	if (kstrtobool(buf, &enable) < 0)
> +		return -EINVAL;
> +
> +	if (pdev->driver)
> +		return -EBUSY;
> +
> +	if (enable) {
> +		if (!pcie_rp_10bit_tag_cmp_supported(pdev))
> +			return -EPERM;

Would it make sense to also verify 10-Bit Tag Completer support on the
"disable" path too?   We won't be able to set a value if there is no
support, but nothing will stop us from clearing it regardless - unless
this would be safe to do?  What do you think?

> +		pcie_capability_set_word(pdev, PCI_EXP_DEVCTL2,
> +				PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
> +	} else {
> +		pcie_capability_clear_word(pdev, PCI_EXP_DEVCTL2,
> +				   PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
> +	}
> +
> +	return count;
> +}

[...]
> +> +static umode_t pcie_dev_10bit_tag_attrs_are_visible(struct kobject *kobj,
> +					  struct attribute *a, int n)

The preferred function name for the .is_visible() callback in a case when
there is only a single sysfs attribute being added would be:

  pcie_dev_10bit_tag_attr_is_visible()

Albeit, I appreciate that you followed the existing naming pattern.

	Krzysztof
