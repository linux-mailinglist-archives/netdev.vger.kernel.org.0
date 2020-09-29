Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3174727D3D7
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 18:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgI2QrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 12:47:04 -0400
Received: from mail-n.franken.de ([193.175.24.27]:58156 "EHLO drew.franken.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728299AbgI2QrE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 12:47:04 -0400
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Sep 2020 12:47:03 EDT
Received: from [IPv6:2a02:8109:1140:c3d:6859:1f54:4594:75a9] (unknown [IPv6:2a02:8109:1140:c3d:6859:1f54:4594:75a9])
        (Authenticated sender: macmic)
        by drew.franken.de (Postfix) with ESMTPSA id E3DC8734495DD;
        Tue, 29 Sep 2020 18:40:01 +0200 (CEST)
From:   Michael Tuexen <tuexen@fh-muenster.de>
Message-Id: <F02013B3-C485-4998-B68A-26118D8ACF9C@fh-muenster.de>
Content-Type: multipart/signed;
        boundary="Apple-Mail=_72B55D9E-C036-4A77-A253-194F5E74A1CF";
        protocol="application/pkcs7-signature";
        micalg=sha-256
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH net-next 00/15] sctp: Implement RFC6951: UDP Encapsulation
 of SCTP
Date:   Tue, 29 Sep 2020 18:39:59 +0200
In-Reply-To: <cover.1601387231.git.lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
To:     Xin Long <lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=disabled version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on mail-n.franken.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Apple-Mail=_72B55D9E-C036-4A77-A253-194F5E74A1CF
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

> On 29. Sep 2020, at 15:48, Xin Long <lucien.xin@gmail.com> wrote:
>=20
> Description =46rom the RFC:
>=20
>   The Main Reasons:
>=20
>   o  To allow SCTP traffic to pass through legacy NATs, which do not
>      provide native SCTP support as specified in [BEHAVE] and
>      [NATSUPP].
>=20
>   o  To allow SCTP to be implemented on hosts that do not provide
>      direct access to the IP layer.  In particular, applications can
>      use their own SCTP implementation if the operating system does =
not
>      provide one.
>=20
>   Implementation Notes:
>=20
>   UDP-encapsulated SCTP is normally communicated between SCTP stacks
>   using the IANA-assigned UDP port number 9899 (sctp-tunneling) on =
both
>   ends.  There are circumstances where other ports may be used on
>   either end, and it might be required to use ports other than the
>   registered port.
>=20
>   Each SCTP stack uses a single local UDP encapsulation port number as
>   the destination port for all its incoming SCTP packets, this greatly
>   simplifies implementation design.
>=20
>   An SCTP implementation supporting UDP encapsulation MUST maintain a
>   remote UDP encapsulation port number per destination address for =
each
>   SCTP association.  Again, because the remote stack may be using =
ports
>   other than the well-known port, each port may be different from each
>   stack.  However, because of remapping of ports by NATs, the remote
>   ports associated with different remote IP addresses may not be
>   identical, even if they are associated with the same stack.
>=20
>   Because the well-known port might not be used, implementations need
>   to allow other port numbers to be specified as a local or remote UDP
>   encapsulation port number through APIs.
Hi Xin Long,

I really appreciate that UDP encapsulation gets implemented in Linux.

The FreeBSD implementation initially had a bug due to missing text in
RFC6951. Please make sure the implementation also follows
https://www.ietf.org/id/draft-tuexen-tsvwg-sctp-udp-encaps-cons-03.html

The plan is to revise RFC6951 and let RFC6951bis include the contents of
the above Internet Draft. But this most likely will happen after the
NAT document is ready and RFC4960bis finished...

If you want to do some interop testing, a web server supporting SCTP/UDP
is running at interop.fh-muenster.de. You can find a client (phttpget) =
at
https://github.com/NEAT-project/HTTPOverSCTP.

Best regards
Michael

>=20
> Patches:
>=20
>   This patchset is using the udp4/6 tunnel APIs to implement the UDP
>   Encapsulation of SCTP with not much change in SCTP protocol stack
>   and with all current SCTP features keeped in Linux Kernel.
>=20
>   1 - 4: Fix some UDP issues that may be triggered by SCTP over UDP.
>   5 - 7: Process incoming UDP encapsulated packets and ICMP packets.
>   8 -10: Remote encap port's update by sysctl, sockopt and packets.
>   11-14: Process outgoing pakects with UDP encapsulated and its GSO.
>      15: Enable this feature.
>=20
> Tests:
>=20
>  - lksctp-tools/src/func_tests with UDP Encapsulation =
enabled/disabled:
>=20
>      Both make v4test and v6test passed.
>=20
>  - sctp-tests with UDP Encapsulation enabled/disabled:
>=20
>      repeatability/procdumps/sctpdiag/gsomtuchange/extoverflow/
>      sctphashtable passed. Others failed as expected due to those
>      "iptables -p sctp" rules.
>=20
>  - netperf on lo/netns/virtio_net, with gso enabled/disabled and
>    with ip_checksum enabled/disabled, with UDP Encapsulation
>    enabled/disabled:
>=20
>      No clear performance dropped.
>=20
> Xin Long (15):
>  udp: check udp sock encap_type in __udp_lib_err
>  udp6: move the mss check after udp gso tunnel processing
>  udp: do checksum properly in skb_udp_tunnel_segment
>  udp: support sctp over udp in skb_udp_tunnel_segment
>  sctp: create udp4 sock and add its encap_rcv
>  sctp: create udp6 sock and set its encap_rcv
>  sctp: add encap_err_lookup for udp encap socks
>  sctp: add encap_port for netns sock asoc and transport
>  sctp: add SCTP_REMOTE_UDP_ENCAPS_PORT sockopt
>  sctp: allow changing transport encap_port by peer packets
>  sctp: add udphdr to overhead when udp_port is set
>  sctp: call sk_setup_caps in sctp_packet_transmit instead
>  sctp: support for sending packet over udp4 sock
>  sctp: support for sending packet over udp6 sock
>  sctp: enable udp tunneling socks
>=20
> include/net/netns/sctp.h     |   8 +++
> include/net/sctp/constants.h |   2 +
> include/net/sctp/sctp.h      |   9 ++-
> include/net/sctp/sm.h        |   1 +
> include/net/sctp/structs.h   |  13 ++--
> include/uapi/linux/sctp.h    |   7 ++
> net/ipv4/udp.c               |   2 +-
> net/ipv4/udp_offload.c       |  16 +++--
> net/ipv6/udp.c               |   2 +-
> net/ipv6/udp_offload.c       | 154 =
+++++++++++++++++++++----------------------
> net/sctp/associola.c         |   4 ++
> net/sctp/ipv6.c              |  48 ++++++++++----
> net/sctp/output.c            |  22 +++----
> net/sctp/protocol.c          | 145 =
++++++++++++++++++++++++++++++++++++----
> net/sctp/sm_make_chunk.c     |   1 +
> net/sctp/sm_statefuns.c      |   2 +
> net/sctp/socket.c            | 111 +++++++++++++++++++++++++++++++
> net/sctp/sysctl.c            |  53 +++++++++++++++
> 18 files changed, 471 insertions(+), 129 deletions(-)
>=20
> --=20
> 2.1.0
>=20


--Apple-Mail=_72B55D9E-C036-4A77-A253-194F5E74A1CF
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEKow
ggUSMIID+qADAgECAgkA4wvV+K8l2YEwDQYJKoZIhvcNAQELBQAwgYIxCzAJBgNVBAYTAkRFMSsw
KQYDVQQKDCJULVN5c3RlbXMgRW50ZXJwcmlzZSBTZXJ2aWNlcyBHbWJIMR8wHQYDVQQLDBZULVN5
c3RlbXMgVHJ1c3QgQ2VudGVyMSUwIwYDVQQDDBxULVRlbGVTZWMgR2xvYmFsUm9vdCBDbGFzcyAy
MB4XDTE2MDIyMjEzMzgyMloXDTMxMDIyMjIzNTk1OVowgZUxCzAJBgNVBAYTAkRFMUUwQwYDVQQK
EzxWZXJlaW4genVyIEZvZXJkZXJ1bmcgZWluZXMgRGV1dHNjaGVuIEZvcnNjaHVuZ3NuZXR6ZXMg
ZS4gVi4xEDAOBgNVBAsTB0RGTi1QS0kxLTArBgNVBAMTJERGTi1WZXJlaW4gQ2VydGlmaWNhdGlv
biBBdXRob3JpdHkgMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMtg1/9moUHN0vqH
l4pzq5lN6mc5WqFggEcVToyVsuXPztNXS43O+FZsFVV2B+pG/cgDRWM+cNSrVICxI5y+NyipCf8F
XRgPxJiZN7Mg9mZ4F4fCnQ7MSjLnFp2uDo0peQcAIFTcFV9Kltd4tjTTwXS1nem/wHdN6r1ZB+Ba
L2w8pQDcNb1lDY9/Mm3yWmpLYgHurDg0WUU2SQXaeMpqbVvAgWsRzNI8qIv4cRrKO+KA3Ra0Z3qL
NupOkSk9s1FcragMvp0049ENF4N1xDkesJQLEvHVaY4l9Lg9K7/AjsMeO6W/VRCrKq4Xl14zzsjz
9AkH4wKGMUZrAcUQDBHHWekCAwEAAaOCAXQwggFwMA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQU
k+PYMiba1fFKpZFK4OpL4qIMz+EwHwYDVR0jBBgwFoAUv1kgNgB5oKAia4zV8mHSuCzLgkowEgYD
VR0TAQH/BAgwBgEB/wIBAjAzBgNVHSAELDAqMA8GDSsGAQQBga0hgiwBAQQwDQYLKwYBBAGBrSGC
LB4wCAYGZ4EMAQICMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9wa2kwMzM2LnRlbGVzZWMuZGUv
cmwvVGVsZVNlY19HbG9iYWxSb290X0NsYXNzXzIuY3JsMIGGBggrBgEFBQcBAQR6MHgwLAYIKwYB
BQUHMAGGIGh0dHA6Ly9vY3NwMDMzNi50ZWxlc2VjLmRlL29jc3ByMEgGCCsGAQUFBzAChjxodHRw
Oi8vcGtpMDMzNi50ZWxlc2VjLmRlL2NydC9UZWxlU2VjX0dsb2JhbFJvb3RfQ2xhc3NfMi5jZXIw
DQYJKoZIhvcNAQELBQADggEBAIcL/z4Cm2XIVi3WO5qYi3FP2ropqiH5Ri71sqQPrhE4eTizDnS6
dl2e6BiClmLbTDPo3flq3zK9LExHYFV/53RrtCyD2HlrtrdNUAtmB7Xts5et6u5/MOaZ/SLick0+
hFvu+c+Z6n/XUjkurJgARH5pO7917tALOxrN5fcPImxHhPalR6D90Bo0fa3SPXez7vTXTf/D6OWS
T1k+kEcQSrCFWMBvf/iu7QhCnh7U3xQuTY+8npTD5+32GPg8SecmqKc22CzeIs2LgtjZeOJVEqM7
h0S2EQvVDFKvaYwPBt/QolOLV5h7z/0HJPT8vcP9SpIClxvyt7bPZYoaorVyGTkwggWsMIIElKAD
AgECAgcbY7rQHiw9MA0GCSqGSIb3DQEBCwUAMIGVMQswCQYDVQQGEwJERTFFMEMGA1UEChM8VmVy
ZWluIHp1ciBGb2VyZGVydW5nIGVpbmVzIERldXRzY2hlbiBGb3JzY2h1bmdzbmV0emVzIGUuIFYu
MRAwDgYDVQQLEwdERk4tUEtJMS0wKwYDVQQDEyRERk4tVmVyZWluIENlcnRpZmljYXRpb24gQXV0
aG9yaXR5IDIwHhcNMTYwNTI0MTEzODQwWhcNMzEwMjIyMjM1OTU5WjCBjTELMAkGA1UEBhMCREUx
RTBDBgNVBAoMPFZlcmVpbiB6dXIgRm9lcmRlcnVuZyBlaW5lcyBEZXV0c2NoZW4gRm9yc2NodW5n
c25ldHplcyBlLiBWLjEQMA4GA1UECwwHREZOLVBLSTElMCMGA1UEAwwcREZOLVZlcmVpbiBHbG9i
YWwgSXNzdWluZyBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAJ07eRxH3h+Gy8Zp
1xCeOdfZojDbchwFfylfS2jxrRnWTOFrG7ELf6Gr4HuLi9gtzm6IOhDuV+UefwRRNuu6cG1joL6W
LkDh0YNMZj0cZGnlm6Stcq5oOVGHecwX064vXWNxSzl660Knl5BpBb+Q/6RAcL0D57+eGIgfn5mI
TQ5HjUhfZZkQ0tkqSe3BuS0dnxLLFdM/fx5ULzquk1enfnjK1UriGuXtQX1TX8izKvWKMKztFwUk
P7agCwf9TRqaA1KgNpzeJIdl5Of6x5ZzJBTN0OgbaJ4YWa52fvfRCng8h0uwN89Tyjo4EPPLR22M
ZD08WkVKusqAfLjz56dMTM0CAwEAAaOCAgUwggIBMBIGA1UdEwEB/wQIMAYBAf8CAQEwDgYDVR0P
AQH/BAQDAgEGMCkGA1UdIAQiMCAwDQYLKwYBBAGBrSGCLB4wDwYNKwYBBAGBrSGCLAEBBDAdBgNV
HQ4EFgQUazqYi/nyU4na4K2yMh4JH+iqO3QwHwYDVR0jBBgwFoAUk+PYMiba1fFKpZFK4OpL4qIM
z+EwgY8GA1UdHwSBhzCBhDBAoD6gPIY6aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9v
dC1nMi1jYS9wdWIvY3JsL2NhY3JsLmNybDBAoD6gPIY6aHR0cDovL2NkcDIucGNhLmRmbi5kZS9n
bG9iYWwtcm9vdC1nMi1jYS9wdWIvY3JsL2NhY3JsLmNybDCB3QYIKwYBBQUHAQEEgdAwgc0wMwYI
KwYBBQUHMAGGJ2h0dHA6Ly9vY3NwLnBjYS5kZm4uZGUvT0NTUC1TZXJ2ZXIvT0NTUDBKBggrBgEF
BQcwAoY+aHR0cDovL2NkcDEucGNhLmRmbi5kZS9nbG9iYWwtcm9vdC1nMi1jYS9wdWIvY2FjZXJ0
L2NhY2VydC5jcnQwSgYIKwYBBQUHMAKGPmh0dHA6Ly9jZHAyLnBjYS5kZm4uZGUvZ2xvYmFsLXJv
b3QtZzItY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQCBeEWkTqR/
DlXwCbFqPnjMaDWpHPOVnj/z+N9rOHeJLI21rT7H8pTNoAauusyosa0zCLYkhmI2THhuUPDVbmCN
T1IxQ5dGdfBi5G5mUcFCMWdQ5UnnOR7Ln8qGSN4IFP8VSytmm6A4nwDO/afr0X9XLchMX9wQEZc+
lgQCXISoKTlslPwQkgZ7nu7YRrQbtQMMONncsKk/cQYLsgMHM8KNSGMlJTx6e1du94oFOO+4oK4v
9NsH1VuEGMGpuEvObJAaguS5Pfp38dIfMwK/U+d2+dwmJUFvL6Yb+qQTkPp8ftkLYF3sv8pBoGH7
EUkp2KgtdRXYShjqFu9VNCIaE40GMIIF4DCCBMigAwIBAgIMIRX9tDE2QqO3mVLXMA0GCSqGSIb3
DQEBCwUAMIGNMQswCQYDVQQGEwJERTFFMEMGA1UECgw8VmVyZWluIHp1ciBGb2VyZGVydW5nIGVp
bmVzIERldXRzY2hlbiBGb3JzY2h1bmdzbmV0emVzIGUuIFYuMRAwDgYDVQQLDAdERk4tUEtJMSUw
IwYDVQQDDBxERk4tVmVyZWluIEdsb2JhbCBJc3N1aW5nIENBMB4XDTE5MDYwNDE0MjkxMFoXDTIy
MDYwMzE0MjkxMFowfDELMAkGA1UEBhMCREUxIDAeBgNVBAoMF0ZhY2hob2Noc2NodWxlIE11ZW5z
dGVyMTIwMAYDVQQLDClGYWNoYmVyZWljaCBFbGVrdHJvdGVjaG5payB1bmQgSW5mb3JtYXRpazEX
MBUGA1UEAwwOTWljaGFlbCBUdWV4ZW4wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDM
r8qQcPxLFCxzPtXvRyM9KeQaxyMA8gwUNc7IIiATs6mRQFe5ib/mvwT9nc0bAa+94go6HJDiD3FJ
NkTo4u8aBsIcTt5pJtdBQLm88PLakbe3+fp/00//n7xxbTh7mAtFVCf25LxDCKkrdGk/+jglRq/R
VdwhZZ3VpYCrx8YfI/hIzdRL3+4I4z/mnQ8K0X8d2MVVPG+9nBEngdnYGez5f/8wIVOgEYYBc21k
yvMnVXLu2Ing+LwBd0gDG9Vasv87MNHCOZfJTNBlLhI2UDei/uNg9Zd4ynlMpPWZ7v0oiDWvmv8E
OuD4oric8heyD0OYK2FL4qcVC4dn4pnyulfHAgMBAAGjggJOMIICSjA+BgNVHSAENzA1MA8GDSsG
AQQBga0hgiwBAQQwEAYOKwYBBAGBrSGCLAEBBAQwEAYOKwYBBAGBrSGCLAIBBAQwCQYDVR0TBAIw
ADAOBgNVHQ8BAf8EBAMCBeAwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMB0GA1UdDgQW
BBTxiodBVL/lA4p5iNesIsJRhhgd6zAfBgNVHSMEGDAWgBRrOpiL+fJTidrgrbIyHgkf6Ko7dDAg
BgNVHREEGTAXgRV0dWV4ZW5AZmgtbXVlbnN0ZXIuZGUwgY0GA1UdHwSBhTCBgjA/oD2gO4Y5aHR0
cDovL2NkcDEucGNhLmRmbi5kZS9kZm4tY2EtZ2xvYmFsLWcyL3B1Yi9jcmwvY2FjcmwuY3JsMD+g
PaA7hjlodHRwOi8vY2RwMi5wY2EuZGZuLmRlL2Rmbi1jYS1nbG9iYWwtZzIvcHViL2NybC9jYWNy
bC5jcmwwgdsGCCsGAQUFBwEBBIHOMIHLMDMGCCsGAQUFBzABhidodHRwOi8vb2NzcC5wY2EuZGZu
LmRlL09DU1AtU2VydmVyL09DU1AwSQYIKwYBBQUHMAKGPWh0dHA6Ly9jZHAxLnBjYS5kZm4uZGUv
ZGZuLWNhLWdsb2JhbC1nMi9wdWIvY2FjZXJ0L2NhY2VydC5jcnQwSQYIKwYBBQUHMAKGPWh0dHA6
Ly9jZHAyLnBjYS5kZm4uZGUvZGZuLWNhLWdsb2JhbC1nMi9wdWIvY2FjZXJ0L2NhY2VydC5jcnQw
DQYJKoZIhvcNAQELBQADggEBABs3VlmIZ1VF3HkaQdjInZYmamRabbdgJ7cz6m6o/agKL7+Vhwx7
1BaaYs2gMa5Nu/GJ3YfdqIsUlYtKdl58Yhp/89E6xBfJkItS+rE8RFdf2XgklGlx7GmsvdA3tId5
b6K6r9a5wpVN0epxY6K8wwpzEib6fJLcHylybQXZ7JSOaLRLp6WU3QPoyTT7FpvAe/0b2MSCbPX4
fc53PCn2aGgXuRFVQeCn1SP1BF3QW1ppkFhcF6G+0JcUxYFAXE6r/71WZBvUHqoG/th2hAwQnS+Y
KhUYh4SZQH3/ursXXJYXQ5vyIhkN1FZlmtWA8+ofdCnoqSTbiSX2Aa/kKbTapwgxggOdMIIDmQIB
ATCBnjCBjTELMAkGA1UEBhMCREUxRTBDBgNVBAoMPFZlcmVpbiB6dXIgRm9lcmRlcnVuZyBlaW5l
cyBEZXV0c2NoZW4gRm9yc2NodW5nc25ldHplcyBlLiBWLjEQMA4GA1UECwwHREZOLVBLSTElMCMG
A1UEAwwcREZOLVZlcmVpbiBHbG9iYWwgSXNzdWluZyBDQQIMIRX9tDE2QqO3mVLXMA0GCWCGSAFl
AwQCAQUAoIIBzzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0yMDA5
MjkxNjM5NTlaMC8GCSqGSIb3DQEJBDEiBCA1ZDV/tSmFAYzENmyk+iJ5+9u9+ZQtqv+IJN9L0IMY
DjCBrwYJKwYBBAGCNxAEMYGhMIGeMIGNMQswCQYDVQQGEwJERTFFMEMGA1UECgw8VmVyZWluIHp1
ciBGb2VyZGVydW5nIGVpbmVzIERldXRzY2hlbiBGb3JzY2h1bmdzbmV0emVzIGUuIFYuMRAwDgYD
VQQLDAdERk4tUEtJMSUwIwYDVQQDDBxERk4tVmVyZWluIEdsb2JhbCBJc3N1aW5nIENBAgwhFf20
MTZCo7eZUtcwgbEGCyqGSIb3DQEJEAILMYGhoIGeMIGNMQswCQYDVQQGEwJERTFFMEMGA1UECgw8
VmVyZWluIHp1ciBGb2VyZGVydW5nIGVpbmVzIERldXRzY2hlbiBGb3JzY2h1bmdzbmV0emVzIGUu
IFYuMRAwDgYDVQQLDAdERk4tUEtJMSUwIwYDVQQDDBxERk4tVmVyZWluIEdsb2JhbCBJc3N1aW5n
IENBAgwhFf20MTZCo7eZUtcwDQYJKoZIhvcNAQEBBQAEggEAzKQqSIRTGSgCYt9xkXZooB7Tiv6l
430NldOlzQ6ewdIq3X+jgNpTzalZIaxfhiIGsLX0gvYUdp9QA8n7eY+ZutPdVbhDYxlux7vgVxSo
nKio/AXJ4P/wS8VVxD936HiVqi0jnP3Ijj+qAYMw2VkXavctnVJCracMmyN6qKzMpawjrjeVJ9Pd
cGamlq4WhmZ387JhDrOk/WJ9+WAO2Iqcpm+ri1OWZx3CrhIMTsOBvA2600Y1Eq+jYiQBT9drKe/N
K0M6cCJmGF/ryh8CG1SCIH61b9QVn00y/lvKVuX9ff/kiSOIBSsz6gVJ/KD+zoDuApK4j7kKuqVb
0zHNxRkNxQAAAAAAAA==
--Apple-Mail=_72B55D9E-C036-4A77-A253-194F5E74A1CF--
